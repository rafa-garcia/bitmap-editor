# frozen_string_literal: true

describe 'bin/bitmap_editor' do
  before { skip }

  def run_script(*args)
    @out, @err = capture_subprocess_io do
      system "#{script_path} #{args.join(' ')}"
    end
  end

  let(:script_path)  { File.join('bin', 'bitmap_editor') }
  let(:examples_dir) { File.join('test', 'examples') }

  describe 'when called with no arguments' do
    before do
      run_script
    end

    let(:abort_message) do
      <<~HEREDOC
        Missing argument: [file path]
        Usage: #{script_path} path/to/file
      HEREDOC
    end

    it 'aborts with a message' do
      @err.must_match abort_message
    end
  end

  describe 'when called with an argument' do
    before { run_script(args) }

    let(:args) { [File.join(examples_dir, commands_file)] }

    describe 'and it is invalid' do
      describe 'when the file does not exist' do
        let(:commands_file) { 'non_existent.txt' }

        it 'aborts with a message' do
          @err.must_match "Missing file: #{args.pop} is nowhere to be found"
        end
      end

      describe 'when the file does exist' do
        let(:commands_file) { 'invalid.txt' }

        it 'outputs a message' do
          @out.must_match 'Unrecognised command :('
        end
      end
    end

    describe 'and it is valid' do
      let(:commands_file) { 'show.txt' }

      it 'outputs a message' do
        @out.must_match 'There is no image'
      end
    end
  end
end
