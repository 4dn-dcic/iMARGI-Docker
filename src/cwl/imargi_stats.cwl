#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/imargi:v1.1.1"

- class: "InlineJavascriptRequirement"

inputs:
  distance_type:
    type: string
    inputBinding:
      separate: true
      prefix: "-D"
      position: 1
    default: "5end"

  distance_threshold:
    type: string
    inputBinding:
      separate: true
      prefix: "-D"
      position: 2
    default: "200000"

  pairs_file:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"
      position: 3

  out_file:
    type: string
    inputBinding:
      separate: true
      prefix: "-o"
      position: 4
    default: "out"

outputs:
  stats_file:
    type: File
    outputBinding:
      glob:"$(inputs.outdir + '/' + '*.txt')"

baseCommand: ["imargi_stats.sh"]
