require 'spec_helper'
require 'messages/apps_droplets_list_message'

module VCAP::CloudController
  describe AppsDropletsListMessage do
    it 'has error messages about parameters' do
      expect(AppsDropletsListMessage.new.error_message).to include 'parameter'
    end

    describe 'fields' do
      it 'accepts a set of fields' do
        message = AppsDropletsListMessage.new({
            states: [],
            page: 1,
            per_page: 5,
            order_by: 'created_at'
          })
        expect(message).to be_valid
      end

      it 'accepts an empty set' do
        message = AppsDropletsListMessage.new
        expect(message).to be_valid
      end

      it 'does not accept a field not in this set' do
        message = AppsDropletsListMessage.new({
            foobar: 'pants',
          })
        expect(message).to be_invalid
        expect(message.errors[:base].length).to eq 1
      end

      describe 'validations' do
        it 'validates states is an array' do
          message = AppsDropletsListMessage.new states: 'not array at all'
          expect(message).to be_invalid
          expect(message.errors[:states].length).to eq 1
        end

        describe 'page' do
          it 'validates it is a number' do
            message = AppsDropletsListMessage.new page: 'not number'
            expect(message).to be_invalid
            expect(message.errors[:page].length).to eq 1
          end

          it 'is invalid if page is 0' do
            message = AppsDropletsListMessage.new page: 0
            expect(message).to be_invalid
            expect(message.errors[:page].length).to eq 1
          end

          it 'is invalid if page is negative' do
            message = AppsDropletsListMessage.new page: -1
            expect(message).to be_invalid
            expect(message.errors[:page].length).to eq 1
          end
        end

        describe 'per_page' do
          it 'validates it is a number' do
            message = AppsDropletsListMessage.new per_page: 'not number'
            expect(message).to be_invalid
            expect(message.errors[:per_page].length).to eq 1
          end

          it 'is invalid if per_page is 0' do
            message = AppsDropletsListMessage.new per_page: 0
            expect(message).to be_invalid
            expect(message.errors[:per_page].length).to eq 1
          end

          it 'is invalid if per_page is negative' do
            message = AppsDropletsListMessage.new per_page: -1
            expect(message).to be_invalid
            expect(message.errors[:per_page].length).to eq 1
          end
        end

        describe 'order_by' do
          describe 'valid values' do
            it 'created_at' do
              message = AppsDropletsListMessage.new order_by: 'created_at'
              expect(message).to be_valid
            end

            it 'updated_at' do
              message = AppsDropletsListMessage.new order_by: 'updated_at'
              expect(message).to be_valid
            end

            describe 'order direction' do
              it 'accepts valid values prefixed with "-"' do
                message = AppsDropletsListMessage.new order_by: '-updated_at'
                expect(message).to be_valid
              end

              it 'accepts valid values prefixed with "+"' do
                message = AppsDropletsListMessage.new order_by: '+updated_at'
                expect(message).to be_valid
              end
            end
          end

          it 'is invalid otherwise' do
            message = AppsDropletsListMessage.new order_by: '+foobar'
            expect(message).to be_invalid
            expect(message.errors[:order_by].length).to eq 1
          end
        end
      end
    end
  end
end
