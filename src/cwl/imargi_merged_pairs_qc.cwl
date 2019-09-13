#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/imargi:v1.1.1_dcic_4"

- class: "InlineJavascriptRequirement"

inputs:
  merged_pairs_stats:
    type: File
    inputBinding:
      position: 1

  output_dir:
    type: string
    inputBinding:
      position: 2
    default: "."

outputs:
  merged_pairs_qc:
    type: File
    outputBinding:
      glob: "$(inputs.output_dir + '/' + 'merged_pairs_qc.json')"

baseCommand: ["imargi_merged_pairs_qc.sh"]
