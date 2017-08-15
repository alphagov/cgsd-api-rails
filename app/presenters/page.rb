class Page
  def initialize(controller)
    @controller = controller
    @breadcrumbs = []
    @display_header_border = true
  end

  attr_accessor :display_header_border
  attr_reader :breadcrumbs
  attr_writer :title

  def title
    if @title.present?
      "#{@title} - Government Service Data"
    else
      'Government Service Data'
    end
  end

  def path
    @controller.request.path
  end
end
