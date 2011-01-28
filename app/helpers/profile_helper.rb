module ProfileHelper

  def sex(bool)
    # Returns the string to localize (male/female) => Ex: es.user.labels.male = Hombre // en.user.labels.female = Female
    if bool == true
      return "user.labels.female"
    else
      return "user.labels.male"
    end
  end
  
  def civil_state(civ, sex)
    case civ
    when 1
      if sex == true 
        return "user.labels.single_female"
      else
        return "user.labels.single_male"
      end
    when 2
      return "user.labels.inrelation"
    when 3
      if sex == true
        return "user.labels.married_female"
      else
        return "user.labels.married_male"
      end
    when 4
      if sex == true
        return "user.labels.divorced_female"
      else
        return "user.labels.divorced_male"
      end
    when 5
      if sex == true
        return "user.labels.widow_female"
      else
        return "user.labels.widow_male"
      end
    end
  end
end
