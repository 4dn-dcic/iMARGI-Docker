#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: ""

- class: "InlineJavascriptRequirement"

inputs:
  fastq_R1:
    type: File
    inputBinding:
      separate: true
      prefix: "-1"
      position: 1

  fastq_R2:
    type: File
    inputBinding:
      separate: true
      prefix: "-2"
      position: 2

  base_name:
    type: string
    inputBinding:
      separate: true
      prefix: "-N"
      position: 3

  output_dir:
    type: string
    inputBinding:
      separate: true
      prefix: "-o"
      position: 4
    default: "."

  nthreads:
    type: int
    inputBinding:
      separate: true
      prefix: "-t"
      position: 5

outputs:
  clean_fastq_R1:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/clean' + '*R1_fastq.gz')"

  clean_fastq_R2:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/clean' + '*R2_fastq.gz')"

baseCommand: ["imargi_clean.sh"]
