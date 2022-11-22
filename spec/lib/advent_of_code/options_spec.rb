RSpec.describe AdventOfCode::Options do
  describe ".from_argv" do
    subject(:options) { described_class.from_argv(args) }
    let(:args) { ["--day", "15", "--year", "2019"] }
    before { Timecop.freeze(Date.parse("2021-10-13")) }


    it "can parse correctly" do
      expect(options).to match(
        a_hash_including(
          day: 15,
          year: 2019,
        )
      )
    end

    context "when no args are given" do
      before { Timecop.freeze(Date.parse("2021-12-13")) }
      let(:args) { [] }

      it "defaults to the most recent valid day" do
        expect(options).to match(
          a_hash_including(
            day: 13,
            year: 2021,
          )
        )
      end
    end

    context "when year is a previous year and day is not given" do
      before { Timecop.freeze(Date.parse("2021-01-01")) }
      let(:args) { ["--year", "2019"] }

      it "defaults to the first day of the given year" do
        expect(options).to match(
          a_hash_including(
            day: 1,
            year: 2019,
          )
        )
      end
    end

    context "when year is given and day is not" do
      let(:args) { ["--year", "2021"] }

      it "defaults to the first day of the given year" do
        expect(options).to match(
          a_hash_including(
            day: 1,
            year: 2021,
          )
        )
      end
    end

    context "when day is given and year is not" do
      let(:args) { ["--day", "12"] }

      context "when the most recent valid day is in the previous year" do
        before { Timecop.freeze(Date.parse("2022-11-13")) }

        it "defaults to the correct year" do
          expect(options).to match(
            a_hash_including(
              day: 12,
              year: 2021,
            )
          )
        end
      end

      context "when the most recent valid day is today" do
        before { Timecop.freeze(Date.parse("2022-12-12")) }

        it "defaults to the correct year" do
          expect(options).to match(
            a_hash_including(
              day: 12,
              year: 2022,
            )
          )
        end
      end

      context "when the most recent valid day is later in the current month" do
        before { Timecop.freeze(Date.parse("2022-12-10")) }

        it "defaults to the correct year" do
          expect(options).to match(
            a_hash_including(
              day: 12,
              year: 2021,
            )
          )
        end
      end
    end
  end
end
