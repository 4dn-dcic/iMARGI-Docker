---
class: "Workflow"
cwlVersion: "v1.0"
fdn_meta:
  category: "processing"
  data_types:
    - "MARGI"
  description: "This is a subworkflow of the MARGI data processing pipeline. It takes a bam file as input, performs parsing, filtering. It produces a pairs output file and a QC report."
  name: "imargi-processing-bam"
  title: "MARGI bam processing"
  workflow_type: "MARGI data analysis"

inputs:
-
  fdn_format: "input_bam"
  id: "#input_bam"
  type:
    - "File"
-
  fdn_format: "chromsizes"
  id: "#chromsize"
  type:
    - "File"
-
  fdn_format: "bed"
  id: "#restrict_frags"
  type:
    - "File"
-
  default: "."
  id: "#output_dir"
  type:
    - "string"
-
  default: "hg38"
  id: "#assembly"
  type:
    - "string"
-
  default: 8
  id: '#nThreads'
  type:
    - "int"

outputs:
-
    fdn_format: "pairs"
    fdn_output_type: "processed"
    fdn_secondary_file_formats:
      - "pairs_px2"
    id: "#out_pairs"
    outputSource: "#imargi-parse/final_pairs"
    type:
      - "File"
-
    fdn_format: "json"
    fdn_output_type: "processed"
    id: "#out_qc"
    outputSource: "#imargi-qc/qc_report"
    type:
      - "File"
requirements:
  -
    class: "InlineJavascriptRequirement"
  -
    class: "ScatterFeatureRequirement"

steps:
  -
    fdn_step_meta:
      analysis_step_types:
        - "parsing"
      description: "parsing bam files"
    id: "#imargi-parse"
    in:
      -
        arg_name: "bam_file"
        fdn_format: "fastq"
        id: "#imargi-parse/bam_file"
        source: "#input_bam"
      -
        arg_name: "chromsizes"
        fdn_format: "chromsize"
        id: "#imargi-parse/chromsizes"
        source: "#chromsize"
      -
        arg_name: "restrict_fragments"
        fdn_format: "bed"
        id: "#imargi-parse/restrict_fragments"
        source: "#restrict_frags"
      -
        arg_name: "nThreads"
        id: "#imargi-parse/nThreads"
        source: "#nThreads"
      -
        arg_name: "assembly"
        id: "#imargi-parse/assembly"
        source: "#assembly"
      -
        arg_name: "output_dir"
        id: "#imargi-parse/output_dir"
        source: "#output_dir"
    out:
      -
        arg_name: "final_pairs"
        fdn_format: "pairs"
        id: "#imargi-parse/final_pairs"
      -
        arg_name: "pipeline_stats"
        fdn_format: "log"
        id: "#imargi-parse/pipeline_stats"
    run: "imargi_parse.cwl"
  -
    fdn_step_meta:
      analysis_step_types:
        - "stats report"
      description: ""
    id: "#imargi-stats"
    in:
      -
        arg_name: "pairs_file"
        fdn_format: "pairs"
        id: "#imargi-stats/pairs_file"
        source: "#imargi-parse/final_pairs"
    out:
      -
        arg_name: "#stats_file"
        fdn_format: "txt"
        id: "#imargi-stats/stats_file"

    run: "imargi_stats.cwl"

  -
    fdn_step_meta:
      analysis_step_types:
        - "QC report"
      description: ""
    id: "#imargi-qc"
    in:
      -
        arg_name: "pipeline_stats"
        fdn_format: "log"
        id: "#imargi-qc/pipeline_stats"
        source: "#imargi-parse/pipeline_stats"
      -
        arg_name: "pairs_stats"
        fdn_format: "txt"
        id: "#imargi-qc/pairs_stats"
        source: "#imargi-stats/stats_file"
    out:
      -
        arg_name: "#qc_report"
        fdn_format: "json"
        id: "#imargi-qc/qc_report"
    run: "imargi_single_pairs_qc.cwl"
