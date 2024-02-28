<#assign element = w.getWorkspace().getModElementByName(data.block).getGeneratableElement()>
{
  "parent": "${modid}:custom/${data.customModelName.split(":")[0]}",
  "textures": {
    "all": "${modid}:block/s${data.texture}",
    "particle": "${modid}:blocks/${data.particleTexture?has_content?then(data.particleTexture, element.particleTexture?has_content?then(element.particleTexture, element.texture))}"
      <#if data.getTextureMap()??>
        <#list data.getTextureMap().entrySet() as texture>,
          "${texture.getKey()}": "${modid}:blocks/${texture.getValue()}"
        </#list>
      </#if>
  },
  "render_type": "${element.getRenderType()}"
}