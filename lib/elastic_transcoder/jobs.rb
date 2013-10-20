module ElasticTranscoder
  require "elastic_transcoder/utilities"
  class Jobs

    def initialize
      @utilities = ElasticTranscoder::Utilities.new
    end

    def jobs_by_pipeline pipeline_id
      action = "jobsByPipeline/#{pipeline_id}"
      headers = @utilities.initialize_headers action, {:method=>"GET", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_get url, headers
    end

    #Valid statuses [Submitted|Progressing|Complete|Canceled|Error"]
    def jobs_by_status status
      action = "jobsByStatus/#{status}"
      headers = @utilities.initialize_headers action, {:method=>"GET", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_get url, headers
    end

    def job job_id
      action = "jobs/#{job_id}"
      headers = @utilities.initialize_headers action, {:method=>"GET", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_get url, headers
    end

    #preset Generic 480p 16:9 => 1351620000000-000020
    def create_job pipeline_id, input_key, outputs
      action = "jobs"

      creation_params = {
        Input: {
          Key: input_key,
          FrameRate: 'auto',
          Resolution: 'auto',
          AspectRatio: 'auto',
          Interlaced: 'auto',
          Container: 'auto'
        },
        Outputs: outputs.map {|output|
          {
            Key: output['key'],
            ThumbnailPattern: output['thumbnail_pattern'] || '',
            Rotate: 'auto',
            PresetId: output['preset_id']
          }
        },
        PipelineId: pipeline_id
      }.to_json

      headers = @utilities.initialize_headers action, {:method=>"POST", :payload=>creation_params}
      url = @utilities.build_url action
      response = @utilities.execute_post url, headers, creation_params
    end

    def delete_job job_id
      action = "jobs/#{job_id}"
      headers = @utilities.initialize_headers action, {:method=>"DELETE", :payload=>""}
      url = @utilities.build_url action
      response = @utilities.execute_delete url, headers
    end

  end
end
