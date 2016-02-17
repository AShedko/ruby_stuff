require 'rspec'
require_relative './frnat'

describe FrNat do
  let(:nums) { FrNat.new }

  context 'General set stuff' do
    it 'empty should be true for an empty set' do
      expect(nums.empty?).to be true
    end
    it 'emtying should work' do
      nums.add(12)
      nums.empty
      expect(nums.empty?).to be true
    end
    it 'a nonempty set should not be "empty" ' do
      nums.add(1)
      expect(nums.empty?).to be false
    end

    it 'finding numbers should be possible' do
      FrNat::DEF_MAX.times { |i| nums.add(i) }
      expect(nums.find(2)).to be true
    end
  end
  context '0-Natural numbers stuff' do
    it '0 should be addable' do
      nums.add(0)
      expect(nums.find(0)).to be true
    end
  end
  context 'Testing the maximum element' do
    it 'max value exception' do
      expect(nums.add(FrNat::DEF_MAX+1)).to raise_error('Max value error')
    end
  end
end
