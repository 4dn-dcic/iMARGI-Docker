#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/imargi:v1.1.1"

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
    default: 1000

  drop:
    type: bool
    inputBinding:
      separate: true
      prefix: "-d"
      position: 10
    default: true

  nThreads:
    type: int
    inputBinding:
      separate: true
      prefix: "-t"
      position: 12
    default: 8

outputs:
  final_pairs:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/' + '*pairs.gz')"

  pipeline_stats:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/' + '*.log')"

baseCommand: ["imargi_parse.sh"]
