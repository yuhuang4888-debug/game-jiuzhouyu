import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

import "../pet/MountPetIllusionView"
import "../pet/OutWardIllusionView"

export class IllusionController extends BaseController {
	public mountpet_illusion_view
	public outward_illusion_view
	InitEvent

	public constructor() {
		super()

		let outwardmodel = OutWardBaseModel.GetInstance()
		let local_enum_OutWardType = enum_OutWardType
		let local_OutWardBaseModel = OutWardBaseModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		this.InitEvent = () => {
			let viewFlag
			let OpenMountPetIllusionView = async (type_id?, illusion_id?) => {
				if (!this.mountpet_illusion_view) {
					let view = window["MountPetIllusionView"]
					this.mountpet_illusion_view = new view()
				}
				let defaultIndex
				if (type_id == local_enum_OutWardType.Horse) {
					defaultIndex = 0
				} else if (type_id == local_enum_OutWardType.Partner) {
					defaultIndex = 1
				} else if (type_id == local_enum_OutWardType.Sprite) {
					defaultIndex = 2
				}
				if (defaultIndex != undefined) {
					this.mountpet_illusion_view.SetDefaultIndex(defaultIndex)
				}
				if (illusion_id != undefined) {
					if (this.mountpet_illusion_view.HasOpen()) {
						if (this.mountpet_illusion_view.nowSelectIndex == defaultIndex && this.mountpet_illusion_view.viewList[defaultIndex]) {
							this.mountpet_illusion_view.viewList[defaultIndex].SelectItem(illusion_id)
						} else {
							this.mountpet_illusion_view.SetSelectIndex(defaultIndex)
						}
					} else {
						this.mountpet_illusion_view.Open(defaultIndex, illusion_id)
					}
				} else {
					this.mountpet_illusion_view.Open()
				}

			}
			outwardmodel.Bind(local_OutWardBaseModel.OPEN_MOUNTPET_ILLUSION_VIEW, OpenMountPetIllusionView)

			let OpenOutWardIllusionView = async (type_id?, illusion_id?) => {
				if (!this.outward_illusion_view) {
					let view = window["OutWardIllusionView"]
					this.outward_illusion_view = new view()
				}
				let defaultIndex
				if (type_id == local_enum_OutWardType.Wings) {
					defaultIndex = 0
				} else if (type_id == local_enum_OutWardType.MagicArr) {
					defaultIndex = 4
				} else if (type_id == local_enum_OutWardType.BackOrnament) {
					defaultIndex = 3
				} else if (type_id == local_enum_OutWardType.HolyDevice) {
					defaultIndex = 2
				} else if (type_id == local_enum_OutWardType.Artifact) {
					defaultIndex = 1
				}
				if (defaultIndex != undefined) {
					this.outward_illusion_view.SetDefaultIndex(defaultIndex)
				}
				if (illusion_id != undefined) {
					if (this.outward_illusion_view.HasOpen()) {
						if (this.outward_illusion_view.nowSelectIndex == defaultIndex && this.outward_illusion_view.viewList[defaultIndex]) {
							this.outward_illusion_view.viewList[defaultIndex].SelectItem(illusion_id)
						} else {
							this.outward_illusion_view.SetSelectIndex(defaultIndex)
						}
					} else {
						this.outward_illusion_view.Open(defaultIndex, illusion_id)
					}
				} else {
					this.outward_illusion_view.Open()
				}

			}
			outwardmodel.Bind(local_OutWardBaseModel.OPEN_OUTWARD_ILLUSION_VIEW, OpenOutWardIllusionView)

			let OpenView = (TypeId?, index?) => {
				if (TypeId == local_enum_OutWardType.Horse || TypeId == local_enum_OutWardType.Partner) {
					OpenMountPetIllusionView(TypeId, index)
				} else if (TypeId == local_enum_OutWardType.Wings || TypeId == local_enum_OutWardType.HolyDevice || TypeId == local_enum_OutWardType.Artifact || TypeId == local_enum_OutWardType.MagicArr || TypeId == local_enum_OutWardType.BackOrnament) {
					OpenOutWardIllusionView(TypeId, index)
				} else if (TypeId == local_enum_OutWardType.Pet) {
					local_GlobalEventSystem.Fire(local_EventName.SWITCH_MOUNT_PET_VIEW, 1, index)
				} else if (TypeId == 142) { // 伙伴
					local_GlobalEventSystem.Fire(local_EventName.SWITCH_MOUNT_PET_VIEW, 2, index)
				}
			}
			local_GlobalEventSystem.Bind(local_EventName.OPEN_ILLUSION_VIEW, OpenView)
		}

		this.InitEvent()
	}

}
window["IllusionController"] = IllusionController