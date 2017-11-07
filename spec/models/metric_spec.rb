require 'rails_helper'

RSpec.describe Metric, type: :model do
  class CustomMetric < Metric
    define do
      item :channel_a, from: ->(metric) { metric.channel_a }, applicable: ->(metric) { metric.channel_a_applicable }
      item :channel_b, from: ->(metric) { metric.channel_b }, applicable: ->(metric) { metric.channel_b_applicable }
    end
  end

  describe '#initialize' do
    it 'initializes the metric items' do
      metric = CustomMetric.new(channel_a: 5, channel_b: 10)
      expect(metric.channel_a).to eq(5)
      expect(metric.channel_b).to eq(10)
    end

    it 'requires all metric items as keyword arguments' do
      expect {
        CustomMetric.new
      }.to raise_error(ArgumentError, 'missing keywords: channel_a, channel_b')

      expect {
        CustomMetric.new(channel_a: 0)
      }.to raise_error(ArgumentError, 'missing keywords: channel_b')
    end
  end

  describe '.from_metrics' do
    it 'extracts values from a monthly service metrics object, using the `from` proc' do
      metrics = double('metrics', channel_a: 10, channel_b: 20)

      metric = CustomMetric.from_metrics(metrics)
      expect(metric.channel_a).to eq(10)
      expect(metric.channel_b).to eq(20)
    end

    it "sets the values as NOT_APPLICABLE if they're nil and not applicable" do
      # Neither metric items are applicable, but if a value has been assigned,
      # it takes precedence.
      metrics = double('metrics', channel_a: 10, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)

      metric = CustomMetric.from_metrics(metrics)
      expect(metric.channel_a).to eq(10)
      expect(metric.channel_b).to eq(Metric::NOT_APPLICABLE)
    end

    it "sets the values as NOT_PROVIDED if they're nil and applicable" do
      metrics = double('metrics', channel_a: 15, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)

      metric = CustomMetric.from_metrics(metrics)
      expect(metric.channel_a).to eq(15)
      expect(metric.channel_b).to eq(Metric::NOT_PROVIDED)
    end
  end

  describe '#applicable?' do
    it 'returns false if any of the items is applicable' do
      metrics = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: false)
      metric = CustomMetric.from_metrics(metrics)
      expect(metric).to be_applicable
    end

    it 'returns false if all of the items are not applicable' do
      metrics = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)
      metric = CustomMetric.from_metrics(metrics)
      expect(metric).to_not be_applicable
    end
  end

  describe '#+ (addition)' do
    it 'sums value items' do
      metrics1 = double('metrics', channel_a: 10, channel_a_applicable: true, channel_b: 40, channel_b_applicable: true)
      metrics2 = double('metrics', channel_a: 20, channel_a_applicable: true, channel_b: 50, channel_b_applicable: true)

      metric1 = CustomMetric.from_metrics(metrics1)
      metric2 = CustomMetric.from_metrics(metrics2)

      result = metric1 + metric2
      expect(result.channel_a).to eq(30)
      expect(result.channel_b).to eq(90)
    end

    it 'two NOT_APPLICABLE items, result in a NOT_APPLICABLE value' do
      metrics1 = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)
      metrics2 = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)

      metric1 = CustomMetric.from_metrics(metrics1)
      metric2 = CustomMetric.from_metrics(metrics2)

      result = metric1 + metric2
      expect(result.channel_a).to eq(Metric::NOT_APPLICABLE)
      expect(result.channel_b).to eq(Metric::NOT_APPLICABLE)
    end

    it 'two NOT_PROVIDED items, result in a NOT_PROVIDED value' do
      metrics1 = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)
      metrics2 = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)

      metric1 = CustomMetric.from_metrics(metrics1)
      metric2 = CustomMetric.from_metrics(metrics2)

      result = metric1 + metric2
      expect(result.channel_a).to eq(Metric::NOT_PROVIDED)
      expect(result.channel_b).to eq(Metric::NOT_PROVIDED)
    end

    it 'with a NOT_APPLICABLE item and a NOT_PROVIDED item, results in a NOT_PROVIDED value' do
      metrics1 = double('metrics', channel_a: nil, channel_a_applicable: false, channel_b: nil, channel_b_applicable: false)
      metrics2 = double('metrics', channel_a: nil, channel_a_applicable: true, channel_b: nil, channel_b_applicable: true)

      metric1 = CustomMetric.from_metrics(metrics1)
      metric2 = CustomMetric.from_metrics(metrics2)

      result = metric1 + metric2
      expect(result.channel_a).to eq(Metric::NOT_PROVIDED)
      expect(result.channel_b).to eq(Metric::NOT_PROVIDED)
    end
  end

  describe '#read_attribute_for_serialization' do
    it do
      metric = CustomMetric.new(channel_a: 5, channel_b: 10)
      expect(metric).to respond_to(:read_attribute_for_serialization)
    end
  end
end