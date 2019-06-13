#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: ""

- class: "InlineJavascriptRequirement"

inputs:
  assembly:
    type: string
    inputBinding:
      separate: true
      prefix: "-r"
      position: 1

  chromsizes:
    type: File
    inputBinding:
      separate: true
      prefix: "-c"
      position: 2

  restrict_fragments:
    type: File
    inputBinding:
      separate: true
      prefix: "-R"
      position: 3

  bam_file:
    type: File
    inputBinding:
      separate: true
      prefix: "-b"
      position: 4

  output_dir:
    type: string
    inputBinding:
      separate: true
      prefix: "-o"
      position: 5
    default: "."

  min_mapq:
    type: int
    inputBinding:
      separate: true
      prefix: "-Q"
      position: 6
    default: 1

  max_inter_align_gap:
    type: int
    inputBinding:
      separate: true
      prefix: "-G"
      position: 7
    default: 20

  offset_restriction_site:
    type: int
    inputBinding:
      separate: true
      prefix: "-O"
      position:8
    default: 0

  max_ligation_size:
    type: int
    inputBinding:
      separate: true
      prefix: "-M"
      position: 9

  drop:
    type: bool
    inputBinding:
      separate: true
      prefix: "-d"
      position: 10
    default: false

  intermediate_dir:
    type: string
    inputBinding:
      separate: true
      prefix: "-D"
      position: 11

  threads:
    type: int
    inputBinding:
      separate: true
      prefix: "-t"
      position: 12


outputs:
  dedup_pairs:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/dedup' + '*pairs.gz')"

  drop_pairs:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/drop' + '*pairs.gz')"

  duplication_pairs:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/duplication' + '*pairs.gz')"

  sorted_pairs:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/sorted' + '*pairs.gz')"

  dedup_pairs:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/dedup' + '*pairs.gz')"

  stats_dedup:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/stats_dedup' + '*txt')"

  stats_final:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/stats_final' + '*txt')"

  unmapped_pairs:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/unmapped' + '*pairs.gz')"

  final_pairs:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/final' + '*pairs.gz')"

  pipeline_stats:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/pipelineStats' + '*.log')"

baseCommand: ["imargi_parse.sh"]
