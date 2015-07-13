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
end
