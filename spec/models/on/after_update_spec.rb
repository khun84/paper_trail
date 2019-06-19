# frozen_string_literal: true

require "spec_helper"
require_dependency "on/after_update"

module On
  RSpec.describe AfterUpdate, type: :model, versioning: true do
    describe "#versions" do
      it "only creates one version record, for the update event" do
        record = described_class.create(name: "Alice")
        record.update(name: "blah")
        record.destroy
        expect(record.versions.length).to(eq(1))
        expect(record.versions.last.event).to(eq("update"))
      end
    end

    context "#paper_trail_event" do
      it "rembembers the custom event name" do
        record = described_class.create(name: "Alice")
        record.paper_trail_event = "banana"
        record.update(name: "blah")
        record.destroy
        expect(record.versions.length).to(eq(1))
        expect(record.versions.last.event).to(eq("banana"))
      end

      context 'store the after changed record in object' do
        it 'store the after changed record in object' do
          record = described_class.create(name: "Alice")
          record.update(name: "blah")
          record.update(name: "blah blah")
          record.destroy
          expect(record.versions.last.reify.name).to(eq("blah blah"))
        end
      end
    end

    describe "#touch" do
      it "does not create a version" do
        record = described_class.create(name: "Alice")
        expect { record.touch }.not_to(
          change { record.versions.count }
        )
      end
    end
  end
end
