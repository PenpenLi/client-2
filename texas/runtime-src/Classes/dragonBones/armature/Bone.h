﻿/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2012-2017 DragonBones team and other contributors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
#ifndef DRAGONBONES_BONE_H
#define DRAGONBONES_BONE_H

#include "TransformObject.h"
#include "../model/ArmatureData.h"
#include "../animation/AnimationState.h"

DRAGONBONES_NAMESPACE_BEGIN
/**
 * - Bone is one of the most important logical units in the armature animation system,
 * and is responsible for the realization of translate, rotation, scaling in the animations.
 * A armature can contain multiple bones.
 * @see dragonBones.BoneData
 * @see dragonBones.Armature
 * @see dragonBones.Slot
 * @version DragonBones 3.0
 * @language en_US
 */
/**
 * - 骨骼在骨骼动画体系中是最重要的逻辑单元之一，负责动画中的平移、旋转、缩放的实现。
 * 一个骨架中可以包含多个骨骼。
 * @see dragonBones.BoneData
 * @see dragonBones.Armature
 * @see dragonBones.Slot
 * @version DragonBones 3.0
 * @language zh_CN
 */
class Bone final : public TransformObject
{
    BIND_CLASS_TYPE_A(Bone);

public:
    /**
     * - The offset mode.
     * @see #offset
     * @version DragonBones 5.5
     * @language en_US
     */
    /**
     * - 偏移模式。
     * @see #offset
     * @version DragonBones 5.5
     * @language zh_CN
     */
    OffsetMode offsetMode;
    /**
     * @internal
     * @private
     */
    Transform animationPose;
    /**
     * @internal
     * @private
     */
    bool _transformDirty;
    /**
     * @internal
     * @private
     */
    bool _childrenTransformDirty;
    /**
     * @internal
     * @private
     */
    bool _hasConstraint;
    /**
    * @internal
    * @private
    */
    BlendState _blendState;
    /**
     * @internal
     * @private
     */
    BoneData* _boneData;
    /**
     * @internal
     * @private
     */
    std::vector<int>* _cachedFrameIndices;

private:
    bool _localDirty;
    bool _visible;
    int _cachedFrameIndex;
    /**
     * @private
     */
    void _updateGlobalTransformMatrix(bool isCache);

protected:
    /**
     * @inheritDoc
     */
    void _onClear() override;

public:
    /**
     * @inheritDoc
     */
    virtual void _setArmature(Armature* value) override;

public:
    /**
     * @internal
     * @private
     */
    void init(BoneData* boneData);
    /**
     * @internal
     * @private
     */
    void update(int cacheFrameIndex);
    /**
     * @internal
     * @private
     */
    void updateByConstraint();
    /**
     * - Forces the bone to update the transform in the next frame.
     * When the bone is not animated or its animation state is finished, the bone will not continue to update,
     * and when the skeleton must be updated for some reason, the method needs to be called explicitly.
     * @example
     * TypeScript style, for reference only.
     * <pre>
     *     let bone = armature.getBone("arm");
     *     bone.offset.scaleX = 2.0;
     *     bone.invalidUpdate();
     * </pre>
     * @version DragonBones 3.0
     * @language en_US
     */
    /**
     * - 强制骨骼在下一帧更新变换。
     * 当该骨骼没有动画状态或其动画状态播放完成时，骨骼将不在继续更新，而此时由于某些原因必须更新骨骼时，则需要显式调用该方法。
     * @example
     * TypeScript 风格，仅供参考。
     * <pre>
     *     let bone = armature.getBone("arm");
     *     bone.offset.scaleX = 2.0;
     *     bone.invalidUpdate();
     * </pre>
     * @version DragonBones 3.0
     * @language zh_CN
     */
    inline void invalidUpdate()
    {
        _transformDirty = true;
    }
    /**
     * - Check whether the bone contains a specific bone or slot.
     * @see dragonBones.Bone
     * @see dragonBones.Slot
     * @version DragonBones 3.0
     * @language en_US
     */
    /**
     * - 检查该骨骼是否包含特定的骨骼或插槽。
     * @see dragonBones.Bone
     * @see dragonBones.Slot
     * @version DragonBones 3.0
     * @language zh_CN
     */
    bool contains(const TransformObject* value) const;
    /**
     * - The bone data.
     * @version DragonBones 4.5
     * @language en_US
     */
    /**
     * - 骨骼数据。
     * @version DragonBones 4.5
     * @language zh_CN
     */
    inline const BoneData* getBoneData() const
    {
        return _boneData;
    }
    /**
     * - The visible of all slots in the bone.
     * @default true
     * @see dragonBones.Slot#visible
     * @version DragonBones 3.0
     * @language en_US
     */
    /**
     * - 此骨骼所有插槽的可见。
     * @default true
     * @see dragonBones.Slot#visible
     * @version DragonBones 3.0
     * @language zh_CN
     */
    inline bool getVisible() const
    {
        return _visible;
    }
    void setVisible(bool value);
    /**
     * - The bone name.
     * @version DragonBones 3.0
     * @language en_US
     */
    /**
     * - 骨骼名称。
     * @version DragonBones 3.0
     * @language zh_CN
     */
    inline const std::string& getName() const
    {
        return _boneData->name;
    }

    /**
     * - Deprecated, please refer to {@link dragonBones.Armature#getBones()}.
     * @deprecated
     * @language en_US
     */
    /**
     * - 已废弃，请参考 {@link dragonBones.Armature#getBones()}。
     * @deprecated
     * @language zh_CN
     */
    const std::vector<Bone*> getBones() const;
    /**
     * - Deprecated, please refer to {@link dragonBones.Armature#getSlots()}.
     * @deprecated
     * @language en_US
     */
    /**
     * - 已废弃，请参考 {@link dragonBones.Armature#getSlots()}。
     * @deprecated
     * @language zh_CN
     */
    const std::vector<Slot*> getSlots() const;

public: // For WebAssembly.
    inline int getOffsetMode() const { return (int)offsetMode; }
    inline void setOffsetMode(int value) { offsetMode = (OffsetMode)value; }
};

DRAGONBONES_NAMESPACE_END
#endif // DRAGONBONES_BONE_H
