FactoryGirl.define do
  factory :route do
    map { FactoryGirl.create(:map) }

    trait :AB do
      origin 'A'
      destiny 'B'
      distance 10
    end

    trait :AC do
      origin 'A'
      destiny 'C'
      distance 20
    end

    trait :BD do
      origin 'B'
      destiny 'D'
      distance 15
    end

    trait :CD do
      origin 'C'
      destiny 'D'
      distance 20
    end

    trait :AZ do
      origin 'A'
      destiny 'Z'
      distance 5
    end
  end
end
