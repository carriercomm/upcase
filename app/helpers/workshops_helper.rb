module WorkshopsHelper
  def workshops_json(workshops, callback = nil)
    json = workshops.map! do |workshop|
      workshop_json = workshop.as_json
      workshop_json['workshop'].merge!(url: workshop_url(workshop))
      workshop_json
    end.to_json
    json = "#{callback}(#{json})" if callback
    json.html_safe
  end
end