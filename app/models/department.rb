class Department < ApplicationRecord
  include PgSearch

  has_many :delivery_organisations, primary_key: :id, foreign_key: :department_id
  has_many :services, through: :delivery_organisations

  has_many :metrics, through: :services

  validates_presence_of :natural_key, strict: true
  validates_presence_of :name, strict: true
  validates_presence_of :website, strict: true

  pg_search_scope :search, against: %i(name acronym)

  def self.with_delivery_organisations
    self.joins(:services).distinct
  end

  def to_param
    natural_key
  end

  def metrics_search(search_term, group_by)
    if search_term
      services = case group_by
                 when Metrics::GroupBy::DeliveryOrganisation
                   DeliveryOrganisation.search(search_term).map(&:services).flatten
                 when Metrics::GroupBy::Service
                   Service.search(search_term)
                 else
                   raise RuntimeError
                 end
      return MonthlyServiceMetrics.where(service_id: services.map(&:id))
    end

    metrics
  end

  def delivery_organisations_count
    delivery_organisations.with_services.count
  end

  def services_count
    services.with_published_metrics.count
  end
end
