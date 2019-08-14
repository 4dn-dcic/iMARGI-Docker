---
class: "Workflow"
cwlVersion: "v1.0"
fdn_meta:
  category: "processing"
  data_types:
    - "MARGI"
  description: "This is a subworkflow of the MARGI data processing pipeline. It takes a pairs files as input, performs merging, aggregation and file format conversion. It produces a mcool output file."
  name: "imargi-processing-pairs"
  title: "iMARGI pairs processing"
  workflow_type: "MARGI data analysis"

inputs:
-
  fdn_format: "pairs"
  id: "#input_pairs"
  type:
    -
        items: "File"
        type: "array"
outputs:
-
    fdn_format: "pairs"
    fdn_output_type: "processed"
    fdn_secondary_file_formats:
      - "pairs_px2"
    id: "#merged_pairs"
    outputSource: "#merge-pairs/merged_pairs"
    type:
      - "File"
-
    fdn_format: "mcool"
    fdn_output_type: "processed"
    id: "#out_mcool"
    outputSource: "#imargi-convert/mcool_file"
    type:
      - "File"
-
    fdn_format: "json"
    fdn_output_type: "processed"
    id: "#out_qc"
    outputSource: "#imargi-qc/merged_pairs_qc"
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
        - "merging"
      description: "Merging pair files"
      software_used:
        - "pairix_0.3.3"
    id: "#merge-pairs"
    in:
      -
        arg_name: "input_pairs"
        fdn_cardinality: "array"
        fdn_format: "pairs"
        fdn_type: "data file"
        id: "#merge-pairs/input_pairs"
        source: "#input_pairs"
    out:
      -
        arg_name: "merged_pairs"
        fdn_cardinality: "single"
        fdn_format: "pairs"
        fdn_type: "data file"
        id: "#merge-pairs/merged_pairs"
    run: "merge-pairs.cwl"
  -
    fdn_step_meta:
      analysis_step_types:
        - "aggregation"
        - "file format conversion"
      description: "pairs file is converted to mcool"
    id: "#imargi-convert"
    in:
      -
        arg_name: "pairs_file"
        fdn_format: "pairs"
        id: "#imargi-convert/pairs_file"
        source: "#merge-pairs/merged_pairs"
    out:
      -
        arg_name: "mcool_file"
        fdn_format: "mcool"
        id: "#imargi-convert/mcool_file"
    run: "imargi_convert.cwl"
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
        source: "#merge-pairs/merged_pairs"
    out:
      -
        arg_name: "#stats_file"
        fdn_format: "txt"
        id: "#imargi-stats/stats_file"
    run: "imargi_convert.cwl"
  -
    fdn_step_meta:
      analysis_step_types:
        - "QC report"
      description: ""
    id: "#imargi-qc"
    in:
      -
        arg_name: "merged_pairs_stats"
        fdn_format: "txt"
        id: "#imargi-qc/merged_pairs_stats"
        source: "#imargi-stats/stats_file"
    out:
      -
        arg_name: "#merged_pairs_qc"
        fdn_format: "json"
        id: "#imargi-qc/merged_pairs_qc"
    run: "imargi_merged_pairs_qc.cwl"
