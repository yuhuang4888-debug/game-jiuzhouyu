import { BaseClass } from "../common/BaseClass";

export class PartnerAwakeEvent extends BaseClass {
	public static AWAKE_REQUEST_PROTO = "AWAKE_REQUEST_PROTO" 									//请求协议
	public static AWAKE_OPEN_VIEW = "AWAKE_OPEN_VIEW"											//打开界面
	public static AWAKE_CLOSE_VIEW = "AWAKE_CLOSE_VIEW" 										//关闭界面
	public static PLAY_SWAP_ANIMATION = "PLAY_SWAP_ANIMATION"									//交换动画
	public static PARTNER_AWAKE_UPDATE_RED_DOT = "PARTNER_AWAKE_UPDATE_RED_DOT"					//更新红点
}

window["PartnerAwakeEvent"] = PartnerAwakeEvent