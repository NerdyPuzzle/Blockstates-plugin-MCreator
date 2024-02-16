package net.nerdypuzzle.blockstates;

import net.mcreator.plugin.JavaPlugin;
import net.mcreator.plugin.Plugin;
import net.mcreator.plugin.events.PreGeneratorsLoadingEvent;
import net.nerdypuzzle.blockstates.parts.PluginElementTypes;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Launcher extends JavaPlugin {

	private static final Logger LOG = LogManager.getLogger("Blockstates");

	public Launcher(Plugin plugin) {
		super(plugin);

		addListener(PreGeneratorsLoadingEvent.class, e -> PluginElementTypes.load());

		LOG.info("Blockstates plugin was loaded");
	}

}