---
class: "Workflow"
cwlVersion: "v1.0"
fdn_meta:
  category: "processing"
  data_types:
    - "MARGI"
  description: "This is a subworkflow of the MARGI data processing pipeline. It takes fastq files as input, performs filtering of random bases resulting from library construction, and mapping. It produces a bam output file."
  name: "imargi-processing-fastq"
  title: "iMARGI fastq processing"
  workflow_type: "MARGI data analysis"

inputs:
-
  fdn_format: "fastq"
  id: "#fastq_R1"
  type:
    - "File"
-
  fdn_format: "fastq"
  id: "#fastq_R2"
  type:
    - "File"
-
  default: "."
  id: "#output_dir"
  type:
    - "string"
-
  default: 4
  id: '#nThreads'
  type:
    - "int"
-
  fdn_format: "bwaIndex"
  id: "#bwa_index"
  type:
    - "File"
-
  default: "out"
  id: "#prefix"
  type:
    - "string"

outputs:
-
    fdn_format: "bam"
    fdn_output_type: "processed"
    id: "#out_bam"
    outputSource: "#bwa-mem/out_bam"
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
        - "cleaning"
      description: "cleaning fastq files"
    id: "#imargi-clean"
    in:
      -
        arg_name: "fastq_R1"
        fdn_format: "fastq"
        id: "#imargi-clean/fastq_R1"
        source: "#fastq_R1"
      -
        arg_name: "fastq_R2"
        fdn_format: "fastq"
        id: "#imargi-clean/fastq_R2"
        source: "#fastq_R2"
      -
        arg_name: "nThreads"
        id: "#imargi-clean/nThreads"
        source: "#nThreads"
      -
        arg_name: "output_dir"
        id: "#imargi-clean/output_dir"
        source: "#output_dir"
    out:
      -
        arg_name: "clean_fastq_R1"
        fdn_format: "fastq"
        id: "#imargi-clean/clean_fastq_R1"
      -
        arg_name: "clean_fastq_R2"
        fdn_format: "fastq"
        id: "#imargi-clean/clean_fastq_R2"
    run: "imargi_clean.cwl"
  -
    fdn_step_meta:
      analysis_step_types:
        - "mapping"
      description: ""
    id: "#bwa-mem"
    in:
      -
        arg_name: "#fastq1"
        fdn_format: "fastq"
        id: "#bwa-mem/fastq1"
        source: "#imargi-clean/clean_fastq_R1"
      -
        arg_name: "#fastq2"
        fdn_format: "fastq"
        id: "#bwa-mem/fastq2"
        source: "#imargi-clean/clean_fastq_R2"
      -
        arg_name: "#bwa_index"
        fdn_format: "fastq"
        id: "#bwa-mem/bwa_index"
        source: "#bwa_index"
      -
        arg_name: "#nThreads"
        id: "#bwa-mem/nThreads"
        source: "#nThreads"
      -
        arg_name: "#prefix"
        id: "bwa-mem/prefix"
        source: "#prefix"
      -
        arg_name: "#outdir"
        id: "#bwa-mem/outdir"
        source: "#output_dir"
    out:
      -
        arg_name: "#out_bam"
        fdn_format: "bam"
        id: "#bwa-mem/out_bam"

    run: "bwa-mem.cwl"
