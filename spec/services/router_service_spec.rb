require 'spec_helper'

describe RouterService do
  describe '.shortest_path' do
    subject { router.shortest_path(origin, destiny) }

    let(:map) { FactoryGirl.create(:map) }
    let(:router) { described_class.new(map) }
    let(:origin) { 'A' }
    let(:destiny) { 'B' }

    context 'when dont have any route' do
      it { is_expected.to eq(nil) }

      it 'log when has exception' do
        expect(Rails.logger).to receive(:info)
          .with('Error to search shortest path: No routes for this map').once
        subject
      end
    end

    context 'when have one route' do
      before do
        FactoryGirl.create(:route, :AB, map: map)
      end

      it 'get shortest path' do
        is_expected.to eq(
          ['A-B', { distance: 10, alias: 'A-B', origin: 'A', destiny: 'B' }]
        )
      end
    end

    context 'when have two routes with same origin' do
      before do
        FactoryGirl.create(:route, :AB, map: map)
        FactoryGirl.create(:route, :AC, map: map)
      end

      it 'get shortest path' do
        is_expected.to eq(
          ['A-B', { distance: 10, alias: 'A-B', origin: 'A', destiny: 'B' }]
        )
      end
    end

    context 'when path have 3 steps and 2 paths' do
      let(:destiny) { 'D' }

      before do
        FactoryGirl.create(:route, :AB, map: map)
        FactoryGirl.create(:route, :AC, map: map)
        FactoryGirl.create(:route, :BD, map: map)
        FactoryGirl.create(:route, :CD, map: map)
      end

      it 'get shortest path' do
        is_expected.to eq(
          ['A-B-D', { distance: 25, alias: 'A-B-D', origin: 'B', destiny: 'D' }]
        )
      end
    end

    context 'when has a shortest path without children' do
      let(:destiny) { 'D' }

      before do
        FactoryGirl.create(:route, :AB, map: map)
        FactoryGirl.create(:route, :BD, map: map)
        FactoryGirl.create(:route, :AZ, map: map)
      end

      it 'get shortest path' do
        is_expected.to eq(
          ['A-B-D', { distance: 25, alias: 'A-B-D', origin: 'B', destiny: 'D' }]
        )
      end
    end

    context 'when has a route with loop' do
      let(:destiny) { 'D' }

      before do
        FactoryGirl.create(:route, :AB, map: map)
        FactoryGirl.create(:route, :BA, map: map)
        FactoryGirl.create(:route, :BD, map: map)
      end

      it 'delete the loop and go ahead' do
        is_expected.to eq(
          ['A-B-D', { distance: 25, alias: 'A-B-D', origin: 'B', destiny: 'D' }]
        )
      end
    end

    context 'when has only a loop route' do
      let(:destiny) { 'D' }

      before do
        FactoryGirl.create(:route, :AB, map: map)
        FactoryGirl.create(:route, :BA, map: map)
      end

      it { is_expected.to eq(nil) }

      it 'log when has exception' do
        expect(Rails.logger).to receive(:info)
          .with('Error to search shortest path: Not found any route').once
        subject
      end
    end
  end

  describe 'response' do
    subject { router.response(['A-B-D', { distance: 25 }], 10, 250) }

    let(:map) { FactoryGirl.create(:map) }
    let(:router) { described_class.new(map) }

    it { is_expected.to eql('rota A-B-D com custo de R$6.25') }
  end
end
