import { Enum_ColorUtil_Dark } from "./../util/ColorUtil"
import { EventName } from "./../common/EventName"
import { GlobalEventSystem } from "./../util/DeclareGlobalVar"
import { TransferJobCardController } from "./TransferJobController"
import { BaseItemRenderer } from "./../common/BaseItemRenderer"
import { RoleManager } from "./../commonModel/RoleManager"
import { Alert, Alert_Type } from "./../alert/Alert"
import { RoleController } from "./../commonController/RoleController"
import { Util, AtlasUrl } from "./../util/Util"
import { PlatformManager } from "./../PlatformManager"

export class TransferJobCardItem extends BaseItemRenderer {
	data;
	need_refresh = false;
	argv: any[];
    WIDTH = 558
    HEIGT = 120
	transferCfg;
	public constructor() {
		super()

		this.base_file = "transferJob"
		this.layout_file = "TransferJobCardItem"
		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
			if (this.need_refresh) {
				this.need_refresh = false;
				this.updateItem.call(this, this.argv)
			}
		}
		this.Load()
	}

	public LoadSuccess() {
		if (PlatformManager.IsEyouEnPlatform()) {
		}
	}
	public InitEvent() {
		Util.AddClickEvent(this.btnSure, () => {
			this.sureCbk()
		}, this, true)
	}

	public updateItem(data: number[]) {
		if (!this.is_loaded) {
			this.need_refresh = true
			this.argv = data;
			return;
		}
		let key = data.join('_')
		let career = data[0]
		this.data = data;
		this.transferCfg = TransferJobCardController.ins.getCareerCfg(career)
		if (!this.transferCfg) return;
		this.imgJob.skin = AtlasUrl('transferJob', `career_${key}`);
		this.lblType.text = this.transferCfg['desc1']
		this.lblDesc.text = this.transferCfg['desc2']
	}

	// 确认转职
	public sureCbk() {
		let { career } = RoleManager.GetInstance().GetMainRoleVo()
		Alert.Show(`使用转职卡后您的职业由原来的<font color=${Enum_ColorUtil_Dark.GREEN}>${TransferJobCardController.ins.getCareerCfg(career).name}</font>更改为<font color=${Enum_ColorUtil_Dark.GREEN}>${this.transferCfg['name']}</font>
		<br><font color=${Enum_ColorUtil_Dark.RED}>身上穿戴的装备将会自动转换为新职业装备，背包/仓库道具不进行转换！</font>
		<br>转职有风险，请谨慎选择！`, Alert_Type.Two, () => {
			RoleController.GetInstance().SendFmtToGame(13045, 'cc', ...this.data)
		}, null);
		GlobalEventSystem.Fire(EventName.CLOSE_VIEW, 'TransferJobCardView');
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	btnSure: Laya.Image
	lblTransfer: Laya.Label
	imgJob: Laya.Image
	lblDesc: Laya.Label
	lblType: Laya.Label
	public GetComponents() {
		[
			this.btnSure,
			this.lblTransfer,
			this.imgJob,
			this.lblDesc,
			this.lblType,
		]
			= this.GetChildrenByNames([

				"btnSure",
				"lblTransfer",
				"imgJob",
				"lblDesc",
				"lblType",
			])
	}
}
window["TransferJobCardItem"] = TransferJobCardItem