import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { AttentionEvent, AttentionModel } from "../commonModel/AttentionModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import "../attention/AttentionViewLaya"
import "../attention/AttentionView"
/**
 * 关注模块
 * 现在的关注有两种，两个流程都是相互独立的:
 * 一种是通用关注，通过配置ClientAttention配置根据plat_name显示不同的二维码和奖励，点击按钮会复制公众号的文本。
 * 可以通过cfg内attention_open字段和配置内的开服天数/等级限制来控制是否显示。
 * 
 * 第二种是SDK关注，通过sdk获取关注情况和显示二维码。
 *  1.先判断他是满足条件的标识（爱疯）
	2.请求活动数据判断是否领取过奖励，如果还未领取奖励就继续下一点。
	3.在通过sdk判断是否开启关注，如果开启就继续下一点。
	4.添加图标。
	5.打开关注界面调用关注接口，创建回调的二维码图片。
	6.等待sdk接口回调关注成功。
	7.关注成功就显示图标和界面红点，打开界面点击领取后就关闭界面删除图标。
 */
export class AttentionController extends BaseController {
	model: AttentionModel
	custiom_activity_model:CustomActivityModel
	view_dic = {}

	public constructor() {
		super()
		this.model = AttentionModel.GetInstance()
		this.custiom_activity_model = CustomActivityModel.GetInstance()
		this.InitEvent()
		this.RegisterAllProtocals()
	}

	InitEvent(){
		this.model.Bind(AttentionEvent.ATTENTION_OPEN_VIEW, (view_name: string, ...new_args) => {
			let view = this.view_dic[view_name]
			if (!view) {

				let view_class = window[view_name]
				view = new view_class()

				this.view_dic[view_name] = view
			}
			if (view && view != true) {
				view.Open(...new_args)
			}
		})

		this.model.Bind(AttentionEvent.ATTENTION_CLOSE_VIEW, (view_name: string, ...parms) => {
			let view = this.view_dic[view_name]
			if (view && view != true && view.HasOpen()) {
				view.Close()
			}
			delete this.view_dic[view_name]
		})

		this.model.Bind(AttentionEvent.ATTENTION_REQUEST_CCMD_EVENT, (id: number, fmt?: string, ...parms) => {
			this.SendFmtToGame(id, fmt, ...parms)
		})

		this.custiom_activity_model.Bind(CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type, sub_type) => {
			if(base_type == AttentionModel.ActivityBaseType && sub_type == AttentionModel.ActivitySubType){
				this.model.UpdateSdkAttentionActivityRewardState()
			}
		})

		this.custiom_activity_model.Bind(CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type, sub_type) => {
			if(base_type == AttentionModel.ActivityBaseType && sub_type == AttentionModel.ActivitySubType){
				this.model.UpdateSdkAttentionActivityRewardState()
			}
		})
		
		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.model.ResetData()
			this.model.CheckSdkAttentionOpenState()
			this.model.CheckIconOpen()
		})
	}

	RegisterAllProtocals(){

	}

}