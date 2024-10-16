<#assign element = w.getWorkspace().getModElementByName(data.block).getGeneratableElement()>
{
  "parent": "block/${var_model}",
  "textures": {
    "${var_txname}": "${modid}:block/${data.texture}",
    "particle": "${modid}:block/${data.particleTexture?has_content?then(data.particleTexture, element.particleTexture?has_content?then(element.particleTexture, element.texture))}"
  },
  "render_type": "${element.getRenderType()}"
}