<#macro makeBoundingBox positiveBoxes negativeBoxes facing pitchType="floor">
    <#assign actualPositiveBoxes = positiveBoxes()/>
    <#assign actualNegativeBoxes = negativeBoxes()/>
    <#if actualNegativeBoxes?size != 0>Shapes.join(</#if>
    <@mergeBoxes actualPositiveBoxes, facing, pitchType/>
    <#if actualNegativeBoxes?size != 0>
    , <@mergeBoxes actualNegativeBoxes, facing, pitchType/>, BooleanOp.ONLY_FIRST)</#if>
</#macro>

<#macro checkPitchSupport positiveBoxes negativeBoxes facing enablePitch>
	<#if enablePitch>
		switch (state.getValue(FACE)) {
			case FLOOR -> <@makeBoundingBox positiveBoxes negativeBoxes facing "floor"/>;
			case WALL -> <@makeBoundingBox positiveBoxes negativeBoxes facing "wall"/>;
			case CEILING -> <@makeBoundingBox positiveBoxes negativeBoxes facing "ceiling"/>;
		};
	<#else>
		<@makeBoundingBox positiveBoxes negativeBoxes facing/>;
	</#if>
</#macro>

<#macro boundingBoxWithRotation positiveBoxes negativeBoxes noOffset rotationMode enablePitch=false>
	<#if rotationMode == 0>
	return <@makeBoundingBox positiveBoxes negativeBoxes "north"/><#if !noOffset>.move(offset.x, offset.y, offset.z)</#if>;
	<#else>
	return <#if !noOffset>(</#if>
		<#if rotationMode != 5>
			<#assign pitch = (rotationMode == 1 || rotationMode == 3) && enablePitch>
			switch (state.getValue(FACING)) {
				default -> <@checkPitchSupport positiveBoxes negativeBoxes "south" pitch/>
				case NORTH -> <@checkPitchSupport positiveBoxes negativeBoxes "north" pitch/>
				case EAST -> <@checkPitchSupport positiveBoxes negativeBoxes "east" pitch/>
				case WEST -> <@checkPitchSupport positiveBoxes negativeBoxes "west" pitch/>
				<#if rotationMode == 2 || rotationMode == 4>
					case UP -> <@makeBoundingBox positiveBoxes negativeBoxes "up"/>;
					case DOWN -> <@makeBoundingBox positiveBoxes negativeBoxes "down"/>;
				</#if>
			}
		<#else>
			switch (state.getValue(AXIS)) {
				case X -> <@makeBoundingBox positiveBoxes negativeBoxes "x"/>;
				case Y -> <@makeBoundingBox positiveBoxes negativeBoxes "y"/>;
				case Z -> <@makeBoundingBox positiveBoxes negativeBoxes "z"/>;
			}
		</#if>
		<#if !noOffset>).move(offset.x, offset.y, offset.z)</#if>;
	</#if>
</#macro>

<#macro makeCuboid box facing pitchType>
	<#if facing == "south">
		<#if pitchType == "floor">
			box(${min(16 - box.mx, 16 - box.Mx)}, ${min(box.my, box.My)}, ${min(16 - box.mz, 16 - box.Mz)},
			${max(16 - box.mx, 16 - box.Mx)}, ${max(box.my, box.My)}, ${max(16 - box.mz, 16 - box.Mz)})
		<#elseif pitchType == "ceiling">
			box(${min(box.mx, box.Mx)}, ${min(16 - box.my, 16 - box.My)}, ${min(16 - box.mz, 16 - box.Mz)},
			${max(box.mx, box.Mx)}, ${max(16 - box.my, 16 - box.My)}, ${max(16 - box.mz, 16 - box.Mz)})
		<#elseif pitchType == "wall">
			box(${min(16 - box.mx, 16 - box.Mx)}, ${min(box.mz, box.Mz)}, ${min(box.my, box.My)},
			${max(16 - box.mx, 16 - box.Mx)}, ${max(box.mz, box.Mz)}, ${max(box.my, box.My)})
		</#if>
	<#elseif facing == "east">
		<#if pitchType == "floor">
			box(${min(16 - box.mz, 16 - box.Mz)}, ${min(box.my, box.My)}, ${min(box.mx, box.Mx)},
			${max(16 - box.mz, 16 - box.Mz)}, ${max(box.my, box.My)}, ${max(box.mx, box.Mx)})
		<#elseif pitchType == "ceiling">
			box(${min(16 - box.mz, 16 - box.Mz)}, ${min(16 - box.my, 16 - box.My)}, ${min(16 - box.mx, 16 - box.Mx)},
			${max(16 - box.mz, 16 - box.Mz)}, ${max(16 - box.my, 16 - box.My)}, ${max(16 - box.mx, 16 - box.Mx)})
		<#elseif pitchType == "wall">
			box(${min(box.my, box.My)}, ${min(box.mz, box.Mz)}, ${min(box.mx, box.Mx)},
			${max(box.my, box.My)}, ${max(box.mz, box.Mz)}, ${max(box.mx, box.Mx)})
		</#if>
	<#elseif facing == "west">
		<#if pitchType == "floor">
			box(${min(box.mz, box.Mz)}, ${min(box.my, box.My)}, ${min(16 - box.mx, 16 - box.Mx)},
			${max(box.mz, box.Mz)}, ${max(box.my, box.My)}, ${max(16 - box.mx, 16 - box.Mx)})
		<#elseif pitchType == "ceiling">
			box(${min(box.mz, box.Mz)}, ${min(16 - box.my, 16 - box.My)}, ${min(box.mx, box.Mx)},
			${max(box.mz, box.Mz)}, ${max(16 - box.my, 16 - box.My)}, ${max(box.mx, box.Mx)})
		<#elseif pitchType == "wall">
			box(${min(16 - box.my, 16 - box.My)}, ${min(box.mz, box.Mz)}, ${min(16 - box.mx, 16 - box.Mx)},
			${max(16 - box.my, 16 - box.My)}, ${max(box.mz, box.Mz)}, ${max(16 - box.mx, 16 - box.Mx)})
		</#if>
	<#elseif facing == "up">
		box(${min(box.mx, box.Mx)}, ${min(16 - box.mz, 16 - box.Mz)}, ${min(box.my, box.My)},
		${max(box.mx, box.Mx)}, ${max(16 - box.mz, 16 - box.Mz)}, ${max(box.my, box.My)})
	<#elseif facing == "down" || facing == "z">
		box(${min(box.mx, box.Mx)}, ${min(box.mz, box.Mz)}, ${min(16 - box.my, 16 - box.My)},
		${max(box.mx, box.Mx)}, ${max(box.mz, box.Mz)}, ${max(16 - box.my, 16 - box.My)})
	<#elseif facing == "x">
		box(${min(box.my, box.My)}, ${min(box.mz, box.Mz)}, ${min(box.mx, box.Mx)},
		${max(box.my, box.My)}, ${max(box.mz, box.Mz)}, ${max(box.mx, box.Mx)})
	<#else>
		<#if pitchType == "floor">
			box(${min(box.mx, box.Mx)}, ${min(box.my, box.My)}, ${min(box.mz, box.Mz)},
			${max(box.mx, box.Mx)}, ${max(box.my, box.My)}, ${max(box.mz, box.Mz)})
		<#elseif pitchType == "ceiling">
			box(${min(16 - box.mx, 16 - box.Mx)}, ${min(16 - box.my, 16 - box.My)}, ${min(box.mz, box.Mz)},
			${max(16 - box.mx, 16 - box.Mx)}, ${max(16 - box.my, 16 - box.My)}, ${max(box.mz, box.Mz)})
		<#elseif pitchType == "wall">
			box(${min(box.mx, box.Mx)}, ${min(box.mz, box.Mz)}, ${min(16 - box.my, 16 - box.My)},
			${max(box.mx, box.Mx)}, ${max(box.mz, box.Mz)}, ${max(16 - box.my, 16 - box.My)})
		</#if>
	</#if>
</#macro>

<#function min(a, b)>
	<#return (a < b)?then(a, b)>
</#function>

<#function max(a, b)>
	<#return (a > b)?then(a, b)>
</#function>

<#macro mergeBoxes boxes facing pitchType>
	<#if boxes?size == 1>
		<@makeCuboid boxes.get(0) facing pitchType/>
	<#else>
	Shapes.or(<#list boxes as box>
		<@makeCuboid box facing pitchType/><#sep>,</#list>)
	</#if>
</#macro>

<#macro defineCachedShapes baseName positiveBoxes negativeBoxes rotationMode enablePitch=false>
    <#if rotationMode == 0>
        private static final VoxelShape ${baseName} = <@makeBoundingBox positiveBoxes negativeBoxes "north"/>;
    <#elseif rotationMode == 5>
        private static final VoxelShape ${baseName}_X = <@makeBoundingBox positiveBoxes negativeBoxes "x"/>;
        private static final VoxelShape ${baseName}_Y = <@makeBoundingBox positiveBoxes negativeBoxes "y"/>;
        private static final VoxelShape ${baseName}_Z = <@makeBoundingBox positiveBoxes negativeBoxes "z"/>;
    <#else>
        <#list ["NORTH", "SOUTH", "EAST", "WEST"] as face>
            <#if (rotationMode == 1 || rotationMode == 3) && enablePitch>
                private static final VoxelShape ${baseName}_${face}_FLOOR = <@makeBoundingBox positiveBoxes negativeBoxes face?lower_case "floor"/>;
                private static final VoxelShape ${baseName}_${face}_WALL = <@makeBoundingBox positiveBoxes negativeBoxes face?lower_case "wall"/>;
                private static final VoxelShape ${baseName}_${face}_CEILING = <@makeBoundingBox positiveBoxes negativeBoxes face?lower_case "ceiling"/>;
            <#else>
                private static final VoxelShape ${baseName}_${face} = <@makeBoundingBox positiveBoxes negativeBoxes face?lower_case/>;
            </#if>
        </#list>
        <#if rotationMode == 2 || rotationMode == 4>
            private static final VoxelShape ${baseName}_UP = <@makeBoundingBox positiveBoxes negativeBoxes "up"/>;
            private static final VoxelShape ${baseName}_DOWN = <@makeBoundingBox positiveBoxes negativeBoxes "down"/>;
        </#if>
    </#if>
</#macro>

<#macro cacheShapeSwitch baseName rotationMode enablePitch=false>
    <#if rotationMode == 0>
        ${baseName}
    <#elseif rotationMode == 5>
        switch (state.getValue(AXIS)) {
            case X -> ${baseName}_X;
            case Y -> ${baseName}_Y;
            case Z -> ${baseName}_Z;
            default -> ${baseName}_Y;
        }
    <#else>
        switch (state.getValue(FACING)) {
            case NORTH -> <@_pitchSwitch baseName "NORTH" enablePitch/>;
            case SOUTH -> <@_pitchSwitch baseName "SOUTH" enablePitch/>;
            case EAST -> <@_pitchSwitch baseName "EAST" enablePitch/>;
            case WEST -> <@_pitchSwitch baseName "WEST" enablePitch/>;
            <#if rotationMode == 2 || rotationMode == 4>
                case UP -> ${baseName}_UP;
                case DOWN -> ${baseName}_DOWN;
            </#if>
            default -> <@_pitchSwitch baseName "NORTH" enablePitch/>;
        }
    </#if>
</#macro>

<#macro _pitchSwitch baseName face enablePitch>
    <#if enablePitch>
        switch (state.getValue(FACE)) {
            case FLOOR -> ${baseName}_${face}_FLOOR;
            case WALL -> ${baseName}_${face}_WALL;
            case CEILING -> ${baseName}_${face}_CEILING;
        }
    <#else>
        ${baseName}_${face}
    </#if>
</#macro>