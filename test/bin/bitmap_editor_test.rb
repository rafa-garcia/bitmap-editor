# frozen_string_literal: true

describe 'bin/bitmap_editor' do
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
      _(@err).must_match abort_message
    end
  end

  describe 'when called with an argument' do
    before { run_script(args) }

    let(:args) { [File.join(examples_dir, input_file)] }

    describe 'and it is invalid' do
      describe 'when the file does not exist' do
        let(:input_file) { 'non_existent.txt' }

        it 'aborts with a message' do
          _(@err).must_match "Missing file: #{args.pop} is nowhere to be found"
        end
      end

      describe 'when the file does exist' do
        let(:input_file) { 'invalid.txt' }

        it 'outputs a message' do
          _(@err).must_match 'nrecognised command'
        end
      end
    end

    describe 'and it is valid' do
      describe 'but there is no command to create an image' do
        let(:input_file) { 'show.txt' }

        it 'outputs a message' do
          _(@err).must_match 'there is no image'
        end
      end

      describe 'and there is a command to create an image' do
        let(:input_file) { 'create.txt' }

        it 'creates an image' do
          _(@err).must_match ''
        end
      end

      describe 'and there is a sequence of commands' do
        let(:input_file) { 'example.txt' }
        let(:expected_output) { "OOOOO\nOOZZZ\nAWOOO\nOWOOO\nOWOOO\nOWOOO\n" }

        it 'creates an image' do
          _(@out).must_equal expected_output
        end
      end
    end
  end
end
