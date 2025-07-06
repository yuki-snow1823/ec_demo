require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:stock) }
    it { should validate_presence_of(:author) }

    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:stock).is_greater_than_or_equal_to(0) }

    it { should validate_length_of(:author).is_at_least(1).is_at_most(100) }

    context 'price validations' do
      it 'allows price to be 0' do
        product = build(:product, price: 0)
        expect(product).to be_valid
      end

      it 'does not allow negative price' do
        product = build(:product, price: -1)
        expect(product).not_to be_valid
        expect(product.errors[:price]).to include('must be greater than or equal to 0')
      end

      it 'allows large prices' do
        product = build(:product, price: 999999)
        expect(product).to be_valid
      end
    end

    context 'stock validations' do
      it 'allows stock to be 0' do
        product = build(:product, stock: 0)
        expect(product).to be_valid
      end

      it 'does not allow negative stock' do
        product = build(:product, stock: -1)
        expect(product).not_to be_valid
        expect(product.errors[:stock]).to include('must be greater than or equal to 0')
      end
    end

    context 'author validations' do
      it 'does not allow empty author' do
        product = build(:product, author: '')
        expect(product).not_to be_valid
        expect(product.errors[:author]).to include("can't be blank")
      end

      it 'does not allow author longer than 100 characters' do
        product = build(:product, author: 'a' * 101)
        expect(product).not_to be_valid
        expect(product.errors[:author]).to include('is too long (maximum is 100 characters)')
      end

      it 'allows author with exactly 100 characters' do
        product = build(:product, author: 'a' * 100)
        expect(product).to be_valid
      end
    end
  end

  describe 'associations' do
    it { should have_many(:cart_products) }
    it { should have_many(:carts).through(:cart_products) }
    it { should have_many(:order_products) }
    it { should have_many(:orders).through(:order_products) }
  end

  describe 'factories' do
    it 'creates a valid product' do
      product = build(:product)
      expect(product).to be_valid
    end

    it 'creates an inactive product' do
      product = build(:product, :inactive)
      expect(product).not_to be_active
    end

    it 'creates a free product' do
      product = build(:product, :free)
      expect(product.price).to eq(0)
    end

    it 'creates an out of stock product' do
      product = build(:product, :out_of_stock)
      expect(product.stock).to eq(0)
    end

    it 'creates a programming book' do
      product = build(:product, :programming_book)
      expect(product.name).to eq('Ruby on Rails入門')
      expect(product.author).to eq('山田太郎')
    end

    it 'creates a novel' do
      product = build(:product, :novel)
      expect(product.name).to eq('青春小説')
      expect(product.author).to eq('田中花子')
    end
  end

  describe 'scopes and class methods' do
    let!(:active_book) { create(:product, :programming_book, active: true) }
    let!(:inactive_book) { create(:product, :novel, active: false) }

    it 'returns all products' do
      expect(Product.all).to include(active_book, inactive_book)
    end

    it 'filters active products correctly' do
      active_products = Product.where(active: true)
      expect(active_products).to include(active_book)
      expect(active_products).not_to include(inactive_book)
    end
  end

  describe 'business logic scenarios' do
    context 'when book is available for purchase' do
      it 'has stock and is active' do
        product = create(:product, stock: 5, active: true)
        expect(product.active).to be true
        expect(product.stock).to be > 0
      end
    end

    context 'when book is not available for purchase' do
      it 'can be inactive' do
        product = create(:product, :inactive)
        expect(product.active).to be false
      end

      it 'can be out of stock' do
        product = create(:product, :out_of_stock)
        expect(product.stock).to eq(0)
      end
    end
  end
end
