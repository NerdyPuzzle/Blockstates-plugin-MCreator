package net.nerdypuzzle.blockstates.parts;

import net.mcreator.element.ModElementType;
import net.nerdypuzzle.blockstates.elements.Blockstates;
import net.nerdypuzzle.blockstates.elements.BlockstatesGUI;

import static net.mcreator.element.ModElementTypeLoader.register;

public class PluginElementTypes {
    public static ModElementType<?> BLOCKSTATES;

    public static void load() {

        BLOCKSTATES = register(
                new ModElementType<>("blockstates", (Character) null, BlockstatesGUI::new, Blockstates.class)
        );

    }

}
