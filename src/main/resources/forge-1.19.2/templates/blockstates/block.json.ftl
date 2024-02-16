<#assign element = w.getWorkspace().getModElementByName(data.block).getGeneratableElement()>
{
  "parent": "block/cube_all",
  "textures": {
    "all": "${modid}:block/${data.texture}",
    "particle": "${modid}:block/${data.particleTexture?has_content?then(data.particleTexture, element.particleTexture?has_content?then(element.particleTexture, element.texture))}"
  },
  "render_type": "${element.getRenderType()}"
}