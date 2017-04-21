class BasePresenter
  DATE_FORMAT = '%m-%d-%Y'.freeze

  # def initialize
  # end

  # libraries
  # ==================================================
  # Name : David J. Davis
  # Date :
  # Modified : Tracy A. McCormick
  # Date : 3.27.2017
  #
  # Description: retrieves database record
  #
  # @param - id (int) : nil or int that is the id of the record wanting to be retrieved
  # @return Library database record

  def libraries(id = nil)
    if id.nil?
      Library.includes(:normal_hours).includes(:special_hours).select('id, name')
    else
      Library.includes(:normal_hours).includes(:special_hours).where('id = ?', id)
    end
  end

  # departments
  # ==================================================
  # Name : David J. Davis
  # Date :
  #
  # Description: retrieves database record
  #
  # @param - id (int) : nil or int that is the id of the record wanting to be retrieved
  # @return Library database record

  def departments(id = nil)
    if id.nil?
      Department.includes(:normal_hours).includes(:special_hours).select('id, name')
    else
      Department.includes(:normal_hours).includes(:special_hours).where('id = ?', id).select('id,name')
    end
  end

  # resources_for_list
  # ==================================================
  # Name : David J. Davis
  # Date : 3.23.2017
  #
  # Description: Generates an array of DB Objects and returns that for iteration later.
  #
  # @return resources - id and name of a library or department, or both.
  # @todo needs work, right now the list isn't catecatenated togather, access
  # with resource[0] and resource[1] if no type provided

  def resources_for_list(id = nil, type = nil)
    resources = []
    if id.present? && type == 'library'
      resources << (libraries id)
    elsif type == 'library'
      resources << libraries
    elsif id.present? && type == 'department'
      resources << (departments id)
    elsif type == 'department'
      resources << departments
    else
      resources << departments
      resources << libraries
    end
    resources
  end
end
