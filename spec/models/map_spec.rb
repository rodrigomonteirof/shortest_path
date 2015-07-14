require 'spec_helper'

describe Map do
  describe '.find_routes' do
    subject { map.find_routes(origin) }

    let(:map) { FactoryGirl.create(:map) }
    let(:origin) { 'A' }

    context 'when not have routes' do
      it { is_expected.to eq([]) }
    end

    context 'when have multiple routes' do
      before do
        FactoryGirl.create(:route, :AB, map: map)
        FactoryGirl.create(:route, :BD, map: map)
      end

      it 'filter by origins' do
        is_expected.to eq([Route.find_by(origin: 'A')])
      end
    end
  end

  describe '.load_routes' do
    subject { map.load_routes(routes) }

    let(:map) { FactoryGirl.create(:map) }

    context 'when dont have any route' do
      let(:routes) { nil }

      it { is_expected.to eq(nil) }
    end

    context 'when have one route' do
      let(:routes) { ['A B 10'] }

      it 'set route to map' do
        subject
        expect(map.routes.first).to eql(
          Route.find_by(origin: 'A', destiny: 'B', distance: 10)
        )
      end
    end
  end
end
