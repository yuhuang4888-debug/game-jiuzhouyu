import { RefBoxChildsLayout } from "../util/Util"
import { FriendChatItem } from "./FriendChatItem"

export class FriendMineChatItem extends FriendChatItem {

	public constructor(p) {
		super(p)

		this.base_file = "friend"
		this.layout_file = "FriendMineChatItem"
	}

	nameGroup: Laya.HBox
	_lb_time: Laya.Label
	nameLabel: Laya.Label
	_vip_icon: Laya.Image
	titleGroup: Laya.Box
	_Image1: Laya.Image
	chLabel: Laya.Label
	chatBg_img: Laya.Image
	chatBg: Laya.VBox
	contentLabel
	SpriteGraphic: Laya.Box
	head: Laya.Box
	public GetComponents() {
		[
			this.nameGroup,
			this._lb_time,
			this.nameLabel,
			this._vip_icon,
			this.titleGroup,
			this._Image1,
			this.chLabel,
			this.chatBg_img,
			this.chatBg,
			this.contentLabel,
			this.SpriteGraphic,
			this.head,
		]
			= this.GetChildrenByNames([

				"nameGroup",
				"_lb_time",
				"nameLabel",
				"_vip_icon",
				"titleGroup",
				"_Image1",
				"chLabel",
				"chatBg_img",
				"chatBg",
				"contentLabel",
				"SpriteGraphic",
				"head",
			])
	}

	public nameBoxLayout(){
		RefBoxChildsLayout(this.nameGroup, 2, null, true, "right");
	}

	public layout(dress_id?){
		let bg_width=0
		let bg_height=0
		this.contentLabel.style.leading=5
		if(this.contentLabel.contextHeight==20 ||this.contentLabel.contextHeight==40){
			this.contentLabel.y=this.contentLabel.y+5
		}
		if(this.contentLabel.contextHeight == 20){
			this.display_obj.height = 125	
		}else if (this.contentLabel.contextHeight==50 ){
			this.display_obj.height=150
		}else if(this.contentLabel.contextHeight==78){
			this.display_obj.height=180
		}else if(this.contentLabel.contextHeight == 106) {
			this.display_obj.height = 210
		} else{
			this.display_obj.height=140
		}
		if(dress_id ==2|| dress_id ==3|| dress_id ==4 || dress_id == 5 || dress_id ==6 || dress_id == 7){
			bg_height=this.contentLabel.contextHeight+45
		}else{
			bg_height=this.contentLabel.contextHeight+20
		}
		bg_width=40+this.contentLabel.contextWidth
		if(bg_height<45){
			bg_height=45
		}
		if(bg_width<50){
			bg_width=50
		}
		this.chatBg_img.width=bg_width
		this.chatBg_img.height=bg_height
		if(this.contentLabel.contextWidth<330){
			this.contentLabel.x=330-this.contentLabel.contextWidth
		}
	}
}

window["FriendMineChatItem"] = FriendMineChatItem