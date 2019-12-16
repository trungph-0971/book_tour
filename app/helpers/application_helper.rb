module ApplicationHelper
  def full_title page_title
    base_title = I18n.t(".base_title")
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def get_picture model
    model.pictures.present? ? model.pictures.link.url : Settings.default_picture
  end

  def get_tours
    TourDetail.top3
  end
end
