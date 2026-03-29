package net.nerdypuzzle.blockstates;

import net.mcreator.element.ModElementType;
import net.mcreator.element.types.Block;
import net.mcreator.element.types.Procedure;
import net.mcreator.io.TrackingFileIO;
import net.mcreator.plugin.JavaPlugin;
import net.mcreator.plugin.Plugin;
import net.mcreator.plugin.events.ApplicationLoadedEvent;
import net.mcreator.plugin.events.PreGeneratorsLoadingEvent;
import net.mcreator.plugin.events.ui.ModElementGUIEvent;
import net.mcreator.plugin.events.ui.TabEvent;
import net.mcreator.plugin.events.workspace.MCreatorLoadedEvent;
import net.mcreator.ui.MCreator;
import net.mcreator.ui.component.JSelectableList;
import net.mcreator.ui.minecraft.states.PropertyData;
import net.mcreator.ui.minecraft.states.PropertyDataWithValue;
import net.mcreator.ui.minecraft.states.StateMap;
import net.mcreator.ui.variants.modmaker.ModMaker;
import net.mcreator.workspace.Workspace;
import net.mcreator.workspace.elements.IElement;
import net.mcreator.workspace.elements.ModElement;
import net.nerdypuzzle.blockstates.elements.Blockstates;
import net.nerdypuzzle.blockstates.parts.PluginElementTypes;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.stream.Collectors;

public class Launcher extends JavaPlugin {

	private static final Logger LOG = LogManager.getLogger("Blockstates");

	public Launcher(Plugin plugin) {
		super(plugin);

		addListener(PreGeneratorsLoadingEvent.class, e -> PluginElementTypes.load());
        addListener(MCreatorLoadedEvent.class, e-> {
            Workspace workspace = e.getMCreator().getWorkspace();
            if (workspace.getModElements().stream().anyMatch(me -> me.getType() == PluginElementTypes.BLOCKSTATES)) {
                for (Procedure procedure : workspace.getModElements().stream().filter(me -> me.getType() == ModElementType.PROCEDURE).map(me -> (Procedure) me.getGeneratableElement()).toList()) {
                    procedure.procedurexml = procedure.procedurexml
                            .replace("\"block_set_blockstate\">", "\"block_set_integer_property\"><value name=\"property\"><block type=\"text\"><field name=\"TEXT\">blockstate</field></block></value>")
                            .replace("\"block_get_blockstate\">", "\"blockstate_get_integer_property\"><value name=\"property\"><block type=\"text\"><field name=\"TEXT\">blockstate</field></block></value>")
                            .replace("\"block_with_blockstate\">", "\"blockstate_with_integer_property\"><value name=\"property\"><block type=\"text\"><field name=\"TEXT\">blockstate</field></block></value>");
                    procedure.getModElement().reinit(workspace);
                    workspace.getGenerator().generateElement(procedure);
                    workspace.getWorkspace().getModElementManager().storeModElement(procedure);
                    procedure.finalizeModElementGeneration();
                }
                for (Blockstates blockstates : workspace.getModElements().stream().filter(me -> me.getType() == PluginElementTypes.BLOCKSTATES).map(me -> (Blockstates) me.getGeneratableElement()).toList()) {
                    Block block = (Block) workspace.getModElementByName(blockstates.block).getGeneratableElement();
                    block.customProperties.add(new PropertyDataWithValue<>(new PropertyData.IntegerType("CUSTOM:blockstate", 0, blockstates.getBlockstateAmount()), 0));
                    int blockstateIndex = 0;
                    for (Blockstates.BlockstateListEntry entry : blockstates.blockstateList) {
                        blockstateIndex++;
                        Block.StateEntry newEntry = new Block.StateEntry();
                        newEntry.boundingBoxes = entry.getValidBoundingBoxes();
                        newEntry.customModelName = entry.customModelName;
                        newEntry.renderType = entry.renderType;
                        newEntry.hasCustomBoundingBox = !entry.getValidBoundingBoxes().isEmpty();
                        newEntry.texture = entry.texture;
                        newEntry.textureBack = entry.textureBack;
                        newEntry.textureFront = entry.textureFront;
                        newEntry.textureTop = entry.textureTop;
                        newEntry.textureLeft = entry.textureLeft;
                        newEntry.textureRight = entry.textureRight;
                        newEntry.particleTexture = entry.particleTexture;
                        StateMap stateMap = new StateMap();
                        stateMap.put(block.customProperties.getLast().property(), blockstateIndex);
                        newEntry.stateMap = stateMap;
                        newEntry.setWorkspace(e.getMCreator().getWorkspace());
                        block.states.add(newEntry);
                    }
                    block.getModElement().reinit(workspace);
                    workspace.getGenerator().generateElement(block);
                    workspace.getWorkspace().getModElementManager().storeModElement(block);
                    block.finalizeModElementGeneration();
                    blockstates.getModElement().getAssociatedFiles().forEach(f -> TrackingFileIO.deleteFile(workspace, f));
                    workspace.getModElementManager().removeModElement(blockstates.getModElement());
                    workspace.removeModElement(blockstates.getModElement());
                }
            }
        });

		LOG.info("Blockstates plugin was loaded");
	}

}