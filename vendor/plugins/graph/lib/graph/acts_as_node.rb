class Graph

  def self.redis
    threaded[:redis] ||= connection(*options)
  end

  def self.redis=(connection)
    threaded[:redis] = connection
  end

  def self.threaded
    Thread.current[:graph] ||= {}
  end

  def self.connect(*options)
    self.redis = nil
    @options = options
  end

  def self.connection(*options)
    Redis.connect(*options)
  end

  def self.options
    @options = [] unless defined? @options
    @options
  end

end

class ActAsGraph

  def node
    return Node.new(self)
  end

  # Creates a new relation of the specified kind
  # Ex: User.find(1).new_relation('Friend', User.find(4), true)  => Creates a  bidirectional relation as Friend of user 1 and 4 
  def new_connection(relation_name, other_object, bidi)
    return Relation.create(relation_name, self.node, other_object.node, bidi)
  end

  # Deletes a relation of the specified kind
  # Ex: User.find(1).delete_relation('Friend', User.find(4), true)  => Deletes a bidirectional as Friend of user 1 and 4
  def delete_connection(relation_name, other_object, bidi)
    return Relation.delete(relation_name, self.node, other_object.node, bidi)
  end

  # Shows the connections based on the relation specified for the object
  # Post.find(1).connections('Categories') => Shows all the Categories that the Post belongs to
  # Can be limited, that will be limited to the whole set of data in database
  # Can be sorted by the specified sort tags
  def connections(relation_name, limit = 0)
    return Relation.get_connections(relation_name, self.node, limit)
  end
  
  def connections_sort_by_time(relation_name, start = 0, limit = 0, sort = 'ASC')
    return Relation.get_connections_sort_by_time(relation_name, self.node, start, limit, sort)
  end
  
  def connections_random(relation_name, limit = 2)
    return Relation.get_connections_random(relation_name, self.node, limit)
  end
  
  def connections_skip(relation_name, limit = 0, skip = 0)
    return Relation.get_connections_skip(relation_name, self.node, limit, skip)
  end
  
  def connections_nodes(relation_name)
    return Relation.get_connections_nodes(relation_name, self.node)
  end

  # Returns the number of connections of that object for the specified kind
  # Ex: User.find(1).connections_count('Friend')
  def connections_count(relation_name)
    return Relation.get_connections_count(relation_name, self.node)
  end

  # Returns the connections that the objects have in common with the other object
  # Ex: User.find(1).connections_in_common('Group', User.find(8), 3, 'group_name')
  # Since the collection will contain groups the answer will be the first 3 groups sorted by 'group_name' that both users have in common
  def connections_in_common(relation_name, other_object, limit = 0)
    return Relation.get_common_connections(relation_name, self.node, other_object.node, limit)
  end

  # Returns the number of connections that the objects have in common with the other object
  # Ex: User.find(1).connections_in_common_count('Friend', User.find(9))
  def connections_in_common_count(relation_name, other_object)
    return Relation.get_common_connections_count(relation_name, self.node, other_object.node)
  end

  # Returns the connections that the objects DON'T have in common with the other object
  # Ex: User.find(1).connections_non_common('Group', User.find(8), 3, 'group_name')
  # Since the collection will contain groups the answer will be the first 3 groups sorted by 'group_name' that user(8) does not belong_to
  def connections_non_common(relation_name, other_object, limit = 0, sort = "")
    return Relation.get_diff_connections(relation_name, self.node, other_object.node, limit, sort)
  end

  # Returns the objets that the user referenced does not have/belongs from the object
  # Ex: User.find(1).connections_non_common_count('Friend', User.find(7))
  def connections_non_common_count(relation_name, other_object)
    return Relation.get_diff_connections_count(relation_name, self.node, other_object.node)
  end

  # Returns true if the other object is connected with the invoked object
  # Ex: User.find(1).new_relation('Friend', User.find(7), false)
  #     User.find(1).connected?('Friend', User.find(7)) => true
  #     User.find(7).connected?('Friend', User.find(1)) => false
  def connected?(relation_name, other_object)
    return Relation.connected?(relation_name, self.node, other_object.node)
  end

  def connections_of_connections(relation_name, limit = 0, sort = "")
    return Relation.connections_of_my_connections(relation_name, self.node, limit, sort)
  end
end

class Node

  attr_accessor :class_name, :obj_id
  # sets an object as node (Ex / User.find(1)) 
  def initialize(obj)
    self.class_name = obj.class.to_s
    self.obj_id = obj.id.to_s
  end
  
  def string
    return self.class_name + ":" + self.obj_id
  end

end

class Relation

  attr_accessor :name

  def self.create(name, node1, node2, bidi)
    redis = Graph.redis
    if bidi == true
      if redis.sadd("v:#{name}:#{node1.class_name}:#{node1.obj_id}", "#{node2.class_name}:#{node2.obj_id}") == true and redis.sadd("v:#{name}:#{node2.class_name}:#{node2.obj_id}", "#{node1.class_name}:#{node1.obj_id}") == true and redis.set("v:#{name}:#{node2.class_name}:#{node2.obj_id}:#{node1.class_name}:#{node1.obj_id}", Time.now.to_i) == "OK" and redis.set("v:#{name}:#{node1.class_name}:#{node1.obj_id}:#{node2.class_name}:#{node2.obj_id}", Time.now.to_i) == "OK"
         return true
      else
        return false
      end
    else
      if redis.sadd("v:#{name}:#{node1.class_name}:#{node1.obj_id}", "#{node2.class_name}:#{node2.obj_id}") == true and redis.set("v:#{name}:#{node1.class_name}:#{node1.obj_id}:#{node2.class_name}:#{node2.obj_id}", Time.now.to_i) == "OK"
        return true
      else
        return false
      end
    end
  end

  def self.delete(name, node1, node2, bidi)
    redis = Graph.redis
    if bidi == true
      if redis.srem("v:#{name}:#{node1.class_name}:#{node1.obj_id}", "#{node2.class_name}:#{node2.obj_id}") == true and redis.srem("v:#{name}:#{node2.class_name}:#{node2.obj_id}", "#{node1.class_name}:#{node1.obj_id}") == true
          redis.del("v:#{name}:#{node2.class_name}:#{node2.obj_id}:#{node1.class_name}:#{node1.obj_id}", Time.now.to_i)
          redis.del("v:#{name}:#{node1.class_name}:#{node1.obj_id}:#{node2.class_name}:#{node2.obj_id}", Time.now.to_i)
        return true
      else
        return false
      end
    else
      if redis.srem("v:#{name}:#{node1.class_name}:#{node1.obj_id}", "#{node2.class_name}:#{node2.obj_id}") == true 
        redis.del("v:#{name}:#{node2.class_name}:#{node2.obj_id}:#{node1.class_name}:#{node1.obj_id}", Time.now.to_i)
        return true
      else
        return false
      end
    end
  end

  def self.get_connections(name, node, limit)
    redis = Graph.redis
    smembers = redis.smembers "v:#{name}:#{node.class_name}:#{node.obj_id}"
    if smembers.nil?
      smembers = []
    end
    if limit == 0
      limit = smembers.count
    end
    ids = Array.new
    if smembers.count > 0 
      object_type = smembers[0].split(":")[0]
      smembers.each do |l|
        temp_arr = l.split(':')
        ids << temp_arr[1]
      end
      objects = object_type.to_class.find(ids)
      return objects
    else
      return []
    end
  end
  
  def self.get_connections_random(name, node, limit)
    redis = Graph.redis
    smembers = redis.scard "v:#{name}:#{node.class_name}:#{node.obj_id}"
    ids = Array.new
    
    if smembers > limit
      limit.times do
        member = redis.srandmember("v:#{name}:#{node.class_name}:#{node.obj_id}").split(":")
        ids << member[1]
      end
    else
      smembers.times do 
        member = redis.srandmember("v:#{name}:#{node.class_name}:#{node.obj_id}").split(":")
        ids << member[1]
      end
    end
    if ids.count > 0
      object_type_arr = redis.srandmember "v:#{name}:#{node.class_name}:#{node.obj_id}"
      object_type = object_type_arr.split(':')[0]
      return object_type.to_class.find(ids)
    else
      return []
    end
  end
  
  

  def self.get_connections_sort_by_time(name, node, start = 0, limit = 0, sort = 'ASC')
    redis = Graph.redis
    if limit == 0
      limit = redis.scard "v:#{name}:#{node.class_name}:#{node.obj_id}"
    end
    smembers = redis.sort "v:#{name}:#{node.class_name}:#{node.obj_id}", :by => "v:#{name}:#{node.class_name}:#{node.obj_id}:*", :order => sort, :limit => [start, limit]
    
    if smembers.nil?
      smembers = []
    end

    objects = Array.new
    if smembers.count > 0
      smembers.each do |member|
        object_type = member.split(":")[0]
        id = member.split(":")[1]
        begin
          objects <<  object_type.to_class.find(id)
        rescue
        end
      end
    else
      objects = []
    end
    return objects
  end

  def self.get_connections_skip(name, node, limit, skip)
    redis = Graph.redis
    smembers = redis.smembers "v:#{name}:#{node.class_name}:#{node.obj_id}"
    if smembers.nil?
      smembers = []
    end
    if limit == 0
      limit = smembers.count
    end
    ids = Array.new
    if smembers.count > 0 
      object_type = smembers[0].split(":")[0]
      smembers.each do |l|
        if l.index < (skip - 1)
          temp_arr = l.split(':')
          ids << temp_arr[1]
        end
      end
      objects = object_type.to_class.find(ids)
      return objects
    else
      return []
    end
  end



  def self.get_connections_nodes(name, node)
    redis = Graph.redis
    smembers = redis.smembers "v:#{name}:#{node.class_name}:#{node.obj_id}"
    if smembers.nil?
      smembers = []
    end
    return smembers
  end


  def self.get_connections_count(name, node)
    redis = Graph.redis
    return redis.scard "v:#{name}:#{node.class_name}:#{node.obj_id}"
  end

  def self.get_common_connections(name, node1, node2, limit = 0)
    redis = Graph.redis
    smembers = redis.sinter "v:#{name}:#{node1.class_name}:#{node1.obj_id}", "v:#{name}:#{node2.class_name}:#{node2.obj_id}"
    if limit == 0
      limit = smembers.count
    end
    ids = Array.new
    if smembers.count > 0 
      object_type = smembers[0].split(":")[0]
      smembers.each do |l|
        temp_arr = l.split(':')
        ids << temp_arr[1]
      end
      return object_type.to_class.find(ids, :limit => limit)
    else
      return []
    end
  end

  def self.get_common_connections_count(name, node1, node2)
    redis = Graph.redis
    smembers = redis.sinter "v:#{name}:#{node1.class_name}:#{node1.obj_id}", "v:#{name}:#{node2.class_name}:#{node2.obj_id}"
    return smembers.count
  end

  def self.get_diff_connections(name, node1, node2, limit = 0, sort = false)
    redis = Graph.redis
    temp_arr = redis.sdiff("v:#{name}:#{node1.class_name}:#{node1.obj_id}", "v:#{name}:#{node2.class_name}:#{node2.obj_id}")
    temp_arr = temp_arr | redis.sdiff("v:#{name}:#{node2.class_name}:#{node2.obj_id}", "v:#{name}:#{node1.class_name}:#{node1.obj_id}")
    if temp_arr.include?("#{node1.class_name}:#{node1.obj_id}") == true
      temp_arr.delete("#{node1.class_name}:#{node1.obj_id}")
    end
    if temp_arr.include?("#{node2.class_name}:#{node2.obj_id}") == true
      temp_arr.delete("#{node2.class_name}:#{node2.obj_id}")
    end
    if limit == 0
      limit = temp_arr.count
    end
    ids = Array.new
    if temp_arr.count > 0 
      object_type = temp_arr[0].split(":")[0]
      temp_arr.each do |l|
        temp_arr1 = l.split(':')
        ids << temp_arr1[1]
      end
      return object_type.to_class.find(ids, :limit => limit, :order => sort)
    else
      return []
    end
  end

  def self.get_diff_connections_count(name, node1, node2)
    redis = Graph.redis
    temp_arr = redis.sdiff("v:#{name}:#{node1.class_name}:#{node1.obj_id}", "v:#{name}:#{node2.class_name}:#{node2.obj_id}")
    temp_arr = temp_arr | redis.sdiff("v:#{name}:#{node2.class_name}:#{node2.obj_id}", "v:#{name}:#{node1.class_name}:#{node1.obj_id}")
    if temp_arr.include?("#{node1.class_name}:#{node1.obj_id}") == true
      temp_arr.delete("#{node1.class_name}:#{node1.obj_id}")
    end
    if temp_arr.include?("#{node2.class_name}:#{node2.obj_id}") == true
      temp_arr.delete("#{node2.class_name}:#{node2.obj_id}")
    end
    return temp_arr.count
  end

  def self.connected?(name, node_origin, node_destination)
    redis = Graph.redis
    return redis.sismember("v:#{name}:#{node_origin.class_name}:#{node_origin.obj_id}", "#{node_destination.class_name}:#{node_destination.obj_id}")
  end

  def self.connections_of_my_connections(name, node, limit = 0, sort = "")
    redis = Graph.redis
    connections = redis.smembers "v:#{name}:#{node.class_name}:#{node.obj_id}"
    others_connections = Array.new
    connections.each do |c|
      sp = c.split(':')
      class_name = sp[0]
      obj_id = sp[1]
      others_connections = others_connections | redis.smembers("v:#{name}:#{class_name}:#{obj_id}")
    end
    # Deleting self-references
    if others_connections.include?("#{node.class_name}:#{node.obj_id}") == true
      others_connections.delete("#{node.class_name}:#{node.obj_id}")
    end

    if limit == 0
      limit = others_connections.count
    end
    ids = Array.new
    if others_connections.count > 0 
      object_type = others_connections[0].split(":")[0]
      others_connections.each do |l|
        temp_arr1 = l.split(':')
        ids << temp_arr1[1]
      end
      return object_type.to_class.find(ids, :limit => limit, :order => sort)
    else
      return []
    end
  end
end