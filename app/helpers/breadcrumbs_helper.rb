module BreadcrumbsHelper
  def breadcrumbs
    return '' if page.breadcrumbs.size <= 1

    list = page.breadcrumbs.reverse_each.with_index.reduce(ActiveSupport::SafeBuffer.new) do |output, (crumb, index)|
      content = if crumb.url
                  link_to(crumb.name, crumb.url)
                else
                  content_tag(:span, crumb.name)
                end

      # Wrap previous content in a "ul > li" container, unless this is the first
      # item, in which case don't.
      unless index.zero?
        content += content_tag(:ul, content_tag(:li, output))
      end

      content
    end

    nav = content_tag(:nav, list, 'aria-label' => 'Breadcrumb')
    content_tag(:div, nav, class: 'hierarchical-breadcrumbs')
  end
end
