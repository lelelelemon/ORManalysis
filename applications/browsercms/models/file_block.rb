
  class FileBlock < AbstractFileBlock

    acts_as_content_block :taggable => true
    content_module :core

    has_attachment :file
    validates_attachment_presence :file, :message => "You must upload a file"

    def self.display_name
      "File"
    end

    # Override default behavior to handle STI class when looking up other versions of attachments.
    def attachable_type
      Attachment::FILE_BLOCKS
    end
  end
