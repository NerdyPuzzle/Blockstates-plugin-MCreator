<#assign element = w.getWorkspace().getModElementByName(data.block).getGeneratableElement()>
{
  "parent": "forge:item/default",
  "loader": "forge:composite",
  "children": {
    "part1": {
      "loader": "forge:obj",
      "model": "${modid}:models/item/${data.customModelName.split(":")[0]}.obj",
      "emissive_ambient": true
      <#if data.getTextureMap()??>,
        "textures": {
        <#list data.getTextureMap().entrySet() as texture>
          "#${texture.getKey()}": "${modid}:block/${texture.getValue()}"<#sep>,
        </#list>
        }
      </#if>
    }
  },
  "textures": {
    "particle": "${modid}:block/${data.particleTexture?has_content?then(data.particleTexture, element.particleTexture?has_content?then(element.particleTexture, element.texture))}"
  },
  "render_type": "${element.getRenderType()}"
}