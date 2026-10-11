import { BaseClass } from "../../common/BaseClass";
import { FightFontAniType, FightFontManager, FightFontType, IFightFontData } from "./FightFontManager";
import { Vector2 } from "../../util/Vector2";
import { ResManager } from "../../common/ResManager";
import { GameMath } from "../../util/GameMath";
import { Util } from "../../util/Util";
import { ResInfo } from "../../common/ResInfo";
let Laya_Tween = Laya.Tween
let Laya_Tween_to = Laya.Tween.to
let local_Laya = Laya
export abstract class FightFont extends BaseClass {
	font_mgr: FightFontManager;
	text: Laya.Label;
	img: Laya.Image
	type: FightFontType
	ani_type: FightFontAniType;
	time_id_list = []
	tw: Laya.Tween
	is_tween: boolean = false;

	/**记录受击者的位置信息  用于飘字位置优化 */
	defender_pos_record = null 
	constructor() {
		super();
		this.font_mgr = FightFontManager.GetInstance();
		this.Reset()
	}
	public GetType(): FightFontType {
		return this.type;
	}
	public GetFontAniType(): FightFontAniType {
		return this.ani_type;
	}
	public CreateText(){
		if(!this.text){
			this.text = new local_Laya.Label()
			this.text.fontSize = 36
		}
	}
	public CreateImg(){
		if(!this.img){
			this.img = new local_Laya.Image()
		}
	}
	public Reset() {
		if (this.time_id_list.length > 0) {
			for (let id of this.time_id_list) {
				clearTimeout(id)
			}
			this.time_id_list.length = 0
		}
		if (this.text) {
			Laya_Tween.clearAll(this.text)
		}

		if (this.img) {
			Laya_Tween.clearAll(this.img)
			this.img.source = null
			ResManager.GetInstance().DestroyAllReferenceRes(this.hashCode)
		}

		this.SetVisible(false);
	}
	public TextObjIsNull() {
		return this.text == null;
	}
	public ImgObjIsNull() {
		return this.img == null;
	}
	public SetVisible(visible: boolean) {
		if (this.text) {
			this.text.alpha = visible ? 1 : 0;
			this.text.visible = visible;
		}

		if (this.img) {
			this.img.alpha = visible ? 1 : 0;
			this.img.visible = visible;
		}
	}
	public GetActionStatus() {
		return this.is_tween;
	}

	public DeleteMe() {
		this.Reset();
		if (this.text)
			this.text.destroy()
		this.text = null;
		if (this.img)
			this.img.destroy()
		this.img = null;
		super.DeleteMe();
	}
	/**
	 * 开始动画
	 * @param attacker_pos 攻击者坐标
	 * @param defender_pos 防守者坐标
	 * @param attacker_dir 攻击者朝向
	 * @param defender_dir 防守者朝向
	 * @param attacker_body_height 攻击者身体高度
	 * @param defender_body_height 防守者身体高度
	 */
	protected abstract StartAction(attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number);
	/**
	 * 显示战斗文字
	 * @param font_data 飘字数据
	 * @param str 内容
	 * @param attacker_pos 攻击者坐标
	 * @param defender_pos 防守者坐标
	 * @param attacker_dir 攻击者朝向
	 * @param defender_dir 防守者朝向
	 * @param attacker_body_height 攻击者身体高度
	 * @param defender_body_height 防守者身体高度
	 */
	ShowText?(font_data: IFightFontData, str: string, attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number);
	/**
	 * 显示图片
	 * @param font_data 飘字数据
	 * @param url 图片地址
	 * @param attacker_pos 攻击者坐标
	 * @param defender_pos 防守者坐标
	 * @param attacker_dir 攻击者朝向
	 * @param defender_dir 防守者朝向
	 * @param attacker_body_height 攻击者身体高度
	 * @param defender_body_height 防守者身体高度
	 */
	ShowImg?(font_data: IFightFontData, url: string, attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number);
}

/**
 * 第一种动画类型
 */
export class FightFontOneAni extends FightFont {
	constructor() {
		super();
		this.ani_type = FightFontAniType.One
	}

	protected StartAction(attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.is_tween = true;
		this.defender_pos_record = defender_pos

		// 动画一类型				
		// 1	从玩家和受击者连线的坐标连线的中点，向受击者头顶移动(包含一些偏移处理)			
		// 2	移动过程中从0.75倍大小缩放到1倍大小				
		// 3	移动到头顶后会停 零点几秒 然后往上一小段位移				
		// 4	再往上移的过程中，飘字会缩小，并且渐隐	

		let ani_cfg = FightFontManager.GetInstance().fight_font_ani_data[this.ani_type];

		let pos_x = defender_pos.x - attacker_pos.x
		let pos_y = defender_pos.y - defender_body_height - (attacker_pos.y + attacker_body_height)

		let dir = new Vector2(pos_x, pos_y)
		let dis = dir.normalise() * ani_cfg.lian_xian_bi


		//攻击者的位置
		let began_x = attacker_pos.x + dir.x * dis;
		let began_y = attacker_pos.y - attacker_body_height + dir.y * dis;


		//受击者的位置
		let def_pos_x = defender_pos.x
		let def_pos_y = defender_pos.y - defender_body_height

		//第一段动画运动目标点
		let end_pos = this.GetRandomRangePos(def_pos_x, def_pos_y, began_x, began_y, ani_cfg.end_pos_offset)

		//平移分层
		let current_font_num_ = FightFontManager.GetInstance().GetTweeningFontNum(FightFontAniType.One, defender_pos)
		let offset = Math.ceil(current_font_num_ / ani_cfg.end_split_num) * ani_cfg.end_split_y
		end_pos = this.GetLayerOffsetPos(began_x, began_y, end_pos.x, end_pos.y, offset)


		this.text.x = began_x;
		this.text.y = began_y;

		this.text.scaleX = ani_cfg.start_scale;
		this.text.scaleY = ani_cfg.start_scale;

		Laya_Tween_to(this.text, { scaleX: ani_cfg.end_scale, scaleY: ani_cfg.end_scale }, ani_cfg.scale_time, local_Laya.Ease.sineOut)

		Laya_Tween_to(this.text, { y: end_pos.y, x: end_pos.x }, ani_cfg.move_time, local_Laya.Ease.sineOut, local_Laya.Handler.create(this, () => {

			Laya_Tween_to(this.text, { y: defender_pos.y - defender_body_height - ani_cfg.up_move_dis }, ani_cfg.up_move_time, local_Laya.Ease.quintIn, local_Laya.Handler.create(this, () => {
				this.is_tween = false;
				this.font_mgr.PushFont(this);
			}), ani_cfg.stay_time)

			this.text.scaleX = ani_cfg.up_start_scale;
			this.text.scaleY = ani_cfg.up_start_scale;
			Laya_Tween_to(this.text, { scaleX: ani_cfg.up_end_scale, scaleY: ani_cfg.up_end_scale }, ani_cfg.up_scale_time, local_Laya.Ease.quintIn, null, ani_cfg.stay_time)

			this.text.alpha = ani_cfg.up_start_alpha;
			Laya_Tween_to(this.text, { alpha: ani_cfg.up_end_alpha }, ani_cfg.up_alpha_time, local_Laya.Ease.quintIn, null, ani_cfg.stay_time)
		}))
	}
	public ShowText(font_data: IFightFontData, str: string, attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.CreateText()
		ResManager.GetInstance().LoadFont(this, this.font_mgr.fight_font_2_res_name[font_data.font_type], this.text, 36)
		this.text.text = str
		this.text.anchorX = this.text.anchorY = 0.5

		let layer = this.font_mgr.GetLayer(font_data.layer)
		layer.addChild(this.text)

		this.SetVisible(true);
		this.StartAction(attacker_pos, defender_pos, attacker_dir, defender_dir, attacker_body_height, defender_body_height);
	}

	/**
	 * 动画运动轨迹为直线L1(方向是 B——>A),获取到过点直线L1上一点A的垂线，然后以点A为中心点，在垂线L2划出半径为R的取值范围
	 */
	private GetRandomRangePos(pa_x, pa_y, pb_x, pb_y, offset) {
		//直线1的斜率
		let k = (pa_y - pb_y) / (pa_x - pb_x)

		//直线2 （与直线1垂直）
		let k2 = (-1 / k)  //直线1的垂线斜率
		// let B = line_1_y - k2 * line_1_x   //直线1的垂线截距

		//lin2 :   y = k2*x+B
		//取值范围
		let M = Util.RandomRange(0, offset)
		let angle = Math.atan(k2) * 180 / Math.PI
		let sub_x = Math.cos(angle * Math.PI / 180) * M
		// let sub_y = Math.sin(angle * Math.PI / 180) * M

		//左右偏移方向
		let rad = Util.RandomRange(0, 1)

		//求y2
		let x2 = rad ? pa_x + sub_x : pa_x - sub_x
		let y2 = k2 * x2 + (pa_y - k2 * pa_x)

		return new Vector2(x2, y2)
	}

	/**
	 * 分层偏移
	 * 动画运动轨迹为直线L1(方向是 B——>A),获取到过点直线L1上一点A的垂线，然后以点A为中心点，在垂线L2划出半径为R的取值范围
	 * 对垂线L2进行平移
	 * @param line_1_x 
	 * @param line_1_y 
	 * @param end_pos_x 
	 * @param end_pos_y 
	 * @param M 
	 */
	private GetLayerOffsetPos(pb_x, pb_y, pa_x, pa_y, M) {
		//直线1的斜率
		let k = (pb_y - pa_y) / (pb_x - pa_x)

		let angle = Math.atan(k) * 180 / Math.PI
		let sub_x = Math.cos(angle * Math.PI / 180) * M

		let x2 = pa_x > pb_x ? pa_x + sub_x : pa_x - sub_x
		let y2 = k * x2 + (pb_y - k * pb_x)
		return new Vector2(x2, y2)
	}

}


/**
 * 第二种动画类型
 */
export class FightFontTwoAni extends FightFont {
	static localBackOut(t: number, b: number, c: number, d: number, s: number = 2.70158): number {
		return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
	}

	static localBackOut2(t: number, b: number, c: number, d: number, s: number = 3.70158): number {
		return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
	}

	constructor() {
		super();
		this.ani_type = FightFontAniType.Two
	}

	protected StartAction(attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.is_tween = true;
		this.defender_pos_record = defender_pos

		// 动画二类型				
		// 1	0.5倍大小出现在受击者头上，然后迅速放大至2.5倍，然后回缩到1倍	(包含一些偏移处理)					
		// 		回缩的过程中会有点小反弹				
		// 	1过程中，整个暴击飘字会高亮，高亮的亮度绑定缩放大小（2.5倍为全白）					
		// 2	恢复到原大小后，稍微定住 零点几秒 然后缓慢上移					
		// 3	上移过程中会渐隐					

		let ani_cfg = FightFontManager.GetInstance().fight_font_ani_data[this.ani_type];



		//受击者的位置
		let def_pos_x = defender_pos.x
		let def_pos_y = defender_pos.y - defender_body_height


		//平移分层 对起始位置进行偏移
		let current_font_num_ = FightFontManager.GetInstance().GetTweeningFontNum(FightFontAniType.Two,defender_pos)
		let offset = Math.ceil(current_font_num_ / ani_cfg.end_split_num) * ani_cfg.end_split_y
		

		//初始位置
		this.text.x = def_pos_x
		this.text.y = def_pos_y-offset

		this.text.scaleX = ani_cfg.start_enlarge_scale;
		this.text.scaleY = ani_cfg.start_enlarge_scale;


		Laya_Tween_to(this.text, { scaleX: ani_cfg.end_enlarge_scale, scaleY: ani_cfg.end_enlarge_scale }, ani_cfg.enlarge_scale_time, FightFontTwoAni.localBackOut, local_Laya.Handler.create(this, () => {
			this.text.scaleX = ani_cfg.start_narrow_scale;
			this.text.scaleY = ani_cfg.start_narrow_scale;
			Laya_Tween_to(this.text, { scaleX: ani_cfg.end_narrow_scale, scaleY: ani_cfg.end_narrow_scale }, ani_cfg.narrow_scale_time, FightFontTwoAni.localBackOut2, local_Laya.Handler.create(this, () => {

				Laya_Tween_to(this.text, { y: def_pos_y - ani_cfg.up_move_dis - offset}, ani_cfg.up_move_time, local_Laya.Ease.linearNone, local_Laya.Handler.create(this, () => {
					this.is_tween = false;
					this.font_mgr.PushFont(this);
				}), ani_cfg.stay_time)


				this.text.alpha = ani_cfg.up_start_alpha;
				Laya_Tween_to(this.text, { alpha: ani_cfg.up_end_alpha }, ani_cfg.up_alpha_time, local_Laya.Ease.linearNone, null, ani_cfg.stay_time + 250)

			}))
		}))
	}
	public ShowText(font_data: IFightFontData, str: string, attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.CreateText()
		ResManager.GetInstance().LoadFont(this, this.font_mgr.fight_font_2_res_name[font_data.font_type], this.text, 36)
		this.text.text = str
		this.text.anchorX = this.text.anchorY = 0.5

		let layer = this.font_mgr.GetLayer(font_data.layer)
		layer.addChild(this.text)

		this.SetVisible(true);
		this.StartAction(attacker_pos, defender_pos, attacker_dir, defender_dir, attacker_body_height, defender_body_height);
	}



	/**
	 * 分层偏移
	 * 动画运动轨迹为直线L1(方向是 B——>A),获取到过点直线L1上一点A的垂线，然后以点A为中心点，在垂线L2划出半径为R的取值范围
	 * 对垂线L2进行平移
	 * @param line_1_x 
	 * @param line_1_y 
	 * @param end_pos_x 
	 * @param end_pos_y 
	 * @param M 
	 */
	private GetLayerOffsetPos(pb_x, pb_y, pa_x, pa_y, M) {
		//直线1的斜率
		let k = (pb_y - pa_y) / (pb_x - pa_x)

		let angle = Math.atan(k) * 180 / Math.PI
		let sub_x = Math.cos(angle * Math.PI / 180) * M

		let x2 = pa_x > pb_x ? pa_x + sub_x : pa_x - sub_x
		let y2 = k * x2 + (pb_y - k * pb_x)
		return new Vector2(x2, y2)
	}
}


/**
 * 第三种动画类型
 */
export class FightFontThreeAni extends FightFont {
	constructor() {
		super();
		this.ani_type = FightFontAniType.Three
	}

	protected StartAction(attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.is_tween = true;

		// 动画三类型											
		// 1	从角色头部高度出现，从1倍大小开始变大至2倍大小，然后迅速变回1倍大小						
		// 2		在上面变大变小的过程中，位置从头部坠入腰部高度					
		// 3	从腰部高度缓慢向上移，保持匀速移到头顶上方2倍飘字高度处						
		// 4	开始加速上移，并且渐隐											

		let ani_cfg = FightFontManager.GetInstance().fight_font_ani_data[this.ani_type];

		this.text.x = defender_pos.x
		this.text.y = defender_pos.y - defender_body_height * ani_cfg.down_move_start_ratio;

		this.text.scaleX = ani_cfg.start_enlarge_scale;
		this.text.scaleY = ani_cfg.start_enlarge_scale;


		Laya_Tween_to(this.text, { scaleX: ani_cfg.end_enlarge_scale, scaleY: ani_cfg.end_enlarge_scale }, ani_cfg.enlarge_scale_time, local_Laya.Ease.linearNone, local_Laya.Handler.create(this, () => {
			this.text.scaleX = ani_cfg.start_narrow_scale;
			this.text.scaleY = ani_cfg.start_narrow_scale;
			Laya_Tween_to(this.text, { scaleX: ani_cfg.end_narrow_scale, scaleY: ani_cfg.end_narrow_scale }, ani_cfg.narrow_scale_time, local_Laya.Ease.linearNone)
		}))


		Laya_Tween_to(this.text, { y: defender_pos.y - defender_body_height * ani_cfg.down_move_end_ratio }, ani_cfg.down_move_time, local_Laya.Ease.linearNone, local_Laya.Handler.create(this, () => {
			this.text.y = defender_pos.y - defender_body_height * ani_cfg.up_move_start_ratio;
			Laya_Tween_to(this.text, { y: defender_pos.y - defender_body_height * ani_cfg.up_move_end_ratio }, ani_cfg.up_move_time, local_Laya.Ease.linearNone, local_Laya.Handler.create(this, () => {
				Laya_Tween_to(this.text, { y: defender_pos.y - defender_body_height * ani_cfg.up_move_end_ratio - ani_cfg.up2_move_dis }, ani_cfg.up2_move_time, local_Laya.Ease.expoOut, local_Laya.Handler.create(this, () => {
					this.is_tween = false;
					this.font_mgr.PushFont(this);
				}), ani_cfg.stay_time)

				this.text.alpha = ani_cfg.up2_start_alpha;
				Laya_Tween_to(this.text, { alpha: ani_cfg.up2_end_alpha }, ani_cfg.up2_alpha_time, local_Laya.Ease.expoOut, null, ani_cfg.stay_time)
			}))
		}))



	}
	public ShowText(font_data: IFightFontData, str: string, attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.CreateText()
		ResManager.GetInstance().LoadFont(this, this.font_mgr.fight_font_2_res_name[font_data.font_type], this.text, 36)
		this.text.text = str
		this.text.anchorX = this.text.anchorY = 0.5

		let layer = this.font_mgr.GetLayer(font_data.layer)
		layer.addChild(this.text)

		this.SetVisible(true);
		this.StartAction(attacker_pos, defender_pos, attacker_dir, defender_dir, attacker_body_height, defender_body_height);
	}
}

/**
 * 第四种动画类型
 */
export class FightFontFourAni extends FightFont {
	constructor() {
		super();
		this.ani_type = FightFontAniType.Four
	}

	protected StartAction(attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.is_tween = true;

		// 动画四类型														
		// 	1.出现在头顶，停住1秒展示		
		//  2.往上方移动，同时渐隐						

		let ani_cfg = FightFontManager.GetInstance().fight_font_ani_data[this.ani_type];

		this.text.x = defender_pos.x
		this.text.y = defender_pos.y - defender_body_height

		this.text.scaleX = 0.3
		this.text.scaleY = 0.3

		Laya_Tween_to(this.text, { scaleX: 1, scaleY: 1 }, 200, FightFontTwoAni.localBackOut, null)

		Laya_Tween_to(this.text, { y: defender_pos.y - defender_body_height - ani_cfg.up_move_dis }, ani_cfg.up_move_time, local_Laya.Ease.linearNone, local_Laya.Handler.create(this, () => {
			this.is_tween = false;
			this.font_mgr.PushFont(this);
		}), ani_cfg.stay_time)

		this.text.alpha = ani_cfg.up_start_alpha;
		Laya_Tween_to(this.text, { alpha: ani_cfg.up_end_alpha }, ani_cfg.up_alpha_time, local_Laya.Ease.linearNone, null, ani_cfg.stay_time)
	}
	public ShowText(font_data: IFightFontData, str: string, attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.CreateText()
		ResManager.GetInstance().LoadFont(this, this.font_mgr.fight_font_2_res_name[font_data.font_type], this.text, 36)
		this.text.text = str
		this.text.anchorX = this.text.anchorY = 0.5

		let layer = this.font_mgr.GetLayer(font_data.layer)
		layer.addChild(this.text)

		this.SetVisible(true);
		this.StartAction(attacker_pos, defender_pos, attacker_dir, defender_dir, attacker_body_height, defender_body_height);
	}
}



/**
 * 第五种动画类型
 */
 export class FightFontFiveAni extends FightFont {
	constructor() {
		super();
		this.ani_type = FightFontAniType.Five
	}

	protected StartAction(attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.is_tween = true;
		
		let obj = this.text || this.img
		if(!obj) return

		// 动画五类型									
		// 	1.方向为角色脸朝方向的反方向.
		//  2.先0.75倍大小出现于后脑勺.
		//  3.然后迅速放大至2倍.
		//  4.之后缓慢缩小至1倍.
		//  5.停留一段时间
		//  5.然后消失.			

		let ani_cfg = FightFontManager.GetInstance().fight_font_ani_data[this.ani_type];


		//平移分层 对起始位置进行偏移
		let current_font_num_ = FightFontManager.GetInstance().GetTweeningFontNum2(FightFontAniType.Five)
		let offset = current_font_num_ % ani_cfg.end_split_num * ani_cfg.end_split_y
		
		//初始位置
		if(attacker_dir.x > 0){
			obj.x = defender_pos.x - ani_cfg.born_offset_x
		}
		else{
			obj.x = defender_pos.x + ani_cfg.born_offset_x
		}
		var y = defender_pos.y - defender_body_height - ani_cfg.born_offset_y - offset
		// console.log("---------------StartAction", y, current_font_num_)
		obj.y = y


		obj.scaleX = ani_cfg.start_enlarge_scale;
		obj.scaleY = ani_cfg.start_enlarge_scale;

		Laya_Tween_to(obj, { scaleX: ani_cfg.end_enlarge_scale, scaleY: ani_cfg.end_enlarge_scale }, ani_cfg.enlarge_scale_time, local_Laya.Ease.linearNone, local_Laya.Handler.create(this, () => {
			obj.scaleX = ani_cfg.start_narrow_scale;
			obj.scaleY = ani_cfg.start_narrow_scale;
			Laya_Tween_to(obj, { scaleX: ani_cfg.end_narrow_scale, scaleY: ani_cfg.end_narrow_scale }, ani_cfg.narrow_scale_time, local_Laya.Ease.linearNone, local_Laya.Handler.create(this, () => {
				obj.alpha = ani_cfg.start_alpha;
				Laya_Tween_to(obj, { alpha: ani_cfg.end_alpha}, ani_cfg.alpha_time, local_Laya.Ease.linearNone, local_Laya.Handler.create(this, () => {
					this.is_tween = false;
					this.font_mgr.PushFont(this);
				}), ani_cfg.stay_time)
			}))
		}))
	}
	public ShowImg(font_data: IFightFontData, url: string, attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) {
		this.CreateImg()
		ResManager.GetInstance().SetOutsideImageSprite(this, this.img, url)
		this.img.anchorX = this.img.anchorY = 0.5

		let layer = this.font_mgr.GetLayer(font_data.layer)
		layer.addChild(this.img)

		this.SetVisible(true);
		this.StartAction(attacker_pos, defender_pos, attacker_dir, defender_dir, attacker_body_height, defender_body_height);
	}
}

window["FightFontOneAni"] = FightFontOneAni;
window["FightFontTwoAni"] = FightFontTwoAni;
window["FightFontThreeAni"] = FightFontThreeAni;
window["FightFontFourAni"] = FightFontFourAni;
window["FightFontFiveAni"] = FightFontFiveAni;
window["FightFont"] = FightFont