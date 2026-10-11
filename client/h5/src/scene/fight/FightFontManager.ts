import { FightFont } from "./FightFont";
import { Config } from "../../common/Config";
import { Enum_UILayer, LayerManager } from "../../common/LayerManager";

import "./FightFont"
import { Vector2 } from "../../util/Vector2";
import { Util } from "../../util/Util";
export enum FightFontType {
	/**
	 * 攻击
	 */
	Attack,
	/**
	 * 被击
	 */
	BeAttack,
	/**
	 * 暴击
	 */
	BaoJi,
	/**
	 * 会心
	 */
	HuiXin,
	/**
	 * 卓越
	 */
	ZhuoYue,
	/**
	 * 神巫
	 */
	ShenWu,
	/**
	 * 格挡
	 */
	GeDang,
	/**
	 * 反弹
	 */
	FanTan,
	/**
	 * 流血
	 */
	LiuXue,
	/**
	 * 回复
	 */
	HuiFu,
}
window["FightFontType"] = FightFontType

/**
 * 战斗文字动画类型
 */
export enum FightFontAniType {
	One,
	Two,
	Three,
	Four,
	Five
}
window["FightFontAniType"] = FightFontAniType
let local_FightFontAniType = FightFontAniType
/**
 * 战斗文字层级 越大越前
 */
export enum FightFontLayerType {
	One,
	Two,
	Three,
	Four,
	Five,
	Six //技能飘字专用层
}
window["FightFontLayerType"] = FightFontLayerType

export interface IFightFontData {
	ani_type: FightFontAniType,
	font_type?: FightFontType,
	layer: FightFontLayerType,
	GetStr?(value): string
}

export class FightFontManager {

	static Instance: FightFontManager;
	static GetInstance() {
		if (!FightFontManager.Instance) {
			FightFontManager.Instance = new FightFontManager();
		}
		return FightFontManager.Instance;
	}

	fight_font_2_res_name: { [fight_font_type: string]: string } = {
		[FightFontType.Attack]: "fight_font_attack",
		[FightFontType.BeAttack]: "fight_font_beattack",
		[FightFontType.BaoJi]: "fight_font_baoji",
		[FightFontType.HuiXin]: "fight_font_huixin",
		[FightFontType.ZhuoYue]: "fight_font_zhuoyue",
		[FightFontType.ShenWu]: "fight_font_shenwu",
		[FightFontType.GeDang]: "fight_font_gedang",
		[FightFontType.FanTan]: "fight_font_fantan",
		[FightFontType.LiuXue]: "fight_font_liuxue",
		[FightFontType.HuiFu]: "fight_font_huifu",
	};

	fight_font_ani_data: any = {
		[local_FightFontAniType.One]: {
			/**
			 * 连线比 中点就填0.5
			 */
			lian_xian_bi: 0.2,
			/**
			 * 开始的缩放
			 */
			start_scale: 0.8,
			/**
			 * 结束的缩放
			 */
			end_scale: 1.2,
			/**
			 * 缩放的时间(毫秒)
			 */
			scale_time: 200,
			/**
			 * 移动到头顶的时间(毫秒)
			 */
			move_time: 200,

			/**
			 * 移动结束后等待的时间(毫秒)
			 */
			stay_time: 150,
			/**
			 * 向上移动的位移
			 */
			up_move_dis: 0,
			/**
			 * 向上移动的时间(毫秒)
			 */
			up_move_time: 300,
			/**
			 * 向上开始的缩放值
			 */
			up_start_scale: 1.2,
			/**
			 * 向上结束的缩放值
			 */
			up_end_scale: 0.3,
			/**
			 * 向上缩放的时间(毫秒)
			 */
			up_scale_time: 300,

			/**
			 * 向上开始的透明度
			 */
			up_start_alpha: 100,
			/**
			 * 向上结束的透明度
			 */
			up_end_alpha: 0,
			/**
			 * 向上透明度变化的时间(毫秒)
			 */
			up_alpha_time: 300,

			/**
			 * 目标偏移点 随机范围最大值 
			 */
			end_pos_offset: 75,

			/**
			 * 分层处理 每层数量
			 */
			end_split_num: 3,

			/**
			 * 分层处理 每层偏移像素
			 */
			end_split_y: 15

		},
		[local_FightFontAniType.Two]: {
			/**
			 * 开始放大时的缩放值
			 */
			start_enlarge_scale: 0.5,
			/**
			 * 结束放大时的缩放值
			 */
			end_enlarge_scale: 2.2,
			/**
			 * 放大的时间(毫秒)
			 */
			enlarge_scale_time: 150,

			/**
			 * 开始缩小时的缩放值
			 */
			start_narrow_scale: 2.2,
			/**
			 * 结束缩小时的缩放值
			 */
			end_narrow_scale: 1,
			/**
			 * 缩小的时间(毫秒)
			 */
			narrow_scale_time: 125,

			/**
			 * 停留一会(毫秒)
			 */
			stay_time: 300,

			/**
			* 向上移动的位移
			*/
			up_move_dis: 15,
			/**
			 * 向上移动的时间(毫秒)
			 */
			up_move_time: 400,

			/**
			 * 向上开始的透明度
			 */
			up_start_alpha: 1,
			/**
			 * 向上结束的透明度
			 */
			up_end_alpha: 0,
			/**
			 * 向上透明度变化的时间(毫秒)
			 */
			up_alpha_time: 300,

			/**
			* 分层处理 每层数量
			*/
			end_split_num: 1,

			/**
			 * 分层处理 每层偏移像素
			 */
			end_split_y: 60
		},
		[local_FightFontAniType.Three]: {
			/**
			 * 开始放大时的缩放值
			 */
			start_enlarge_scale: 2,
			/**
			 * 结束放大时的缩放值
			 */
			end_enlarge_scale: 0.9,
			/**
			 * 放大的时间(毫秒)
			 */
			enlarge_scale_time: 60,

			/**
			 * 开始缩小时的缩放值
			 */
			start_narrow_scale: 0.9,
			/**
			 * 结束缩小时的缩放值
			 */
			end_narrow_scale: 1,
			/**
			 * 缩小的时间(毫秒)
			 */
			narrow_scale_time: 60,

			/**
			 * 向下移动开始时文字的高度(填入比例 根据模型高度计算位置 例如 1是头顶，0.5中间，1.2头上)
			 */
			down_move_start_ratio: 1,
			/**
			 * 向下移动结束时文字的高度(填入比例 根据模型高度计算位置 例如 1是头顶，0.5中间，1.2头上)
			 */
			down_move_end_ratio: 1,
			/**
			 * 向下移动时间(毫秒)
			 */
			down_move_time: 0,


			/**
			 * 向上移动开始时文字的高度(填入比例 根据模型高度计算位置 例如 1是头顶，0.5中间，1.2头上)
			 */
			up_move_start_ratio: 1,
			/**
			 * 向上移动结束时文字的高度(填入比例 根据模型高度计算位置 例如 1是头顶，0.5中间，1.2头上)
			 */
			up_move_end_ratio: 1.2,
			/**
			 * 向上移动时间(毫秒)
			 */
			up_move_time: 350,

			/**
			 * 向上移动后停留的时间(毫秒)
			 */
			stay_time: 200,

			/**
			* 二段向上移动的位移
			*/
			up2_move_dis: 20,
			/**
			 * 二段向上移动的时间(毫秒)
			 */
			up2_move_time: 400,

			/**
			 * 二段向上开始的透明度
			 */
			up2_start_alpha: 1,
			/**
			 * 二段向上结束的透明度
			 */
			up2_end_alpha: 0,
			/**
			 * 二段向上透明度变化的时间(毫秒)
			 */
			up2_alpha_time: 400

		},
		[local_FightFontAniType.Four]: {
			/**
			 * 停留时间(毫秒)
			 */
			stay_time: 1000,
			/**
			* 向上移动的位移
			*/
			up_move_dis: 20,
			/**
			 * 向上移动的时间(毫秒)
			 */
			up_move_time: 100,

			/**
			 * 向上开始的透明度
			 */
			up_start_alpha: 1,
			/**
			 * 向上结束的透明度
			 */
			up_end_alpha: 0.5,
			/**
			 * 向上透明度变化的时间(毫秒)
			 */
			up_alpha_time: 100


		},
		[local_FightFontAniType.Five]: {
			/**
			 * 出生时,在头部位置的y轴偏移
			 */
			born_offset_y: 200,
			/**
			 * 出生时,在头部位置的x轴偏移
			 */
			born_offset_x: 10,
			/**
			 * 开始放大时的缩放值
			 */
			start_enlarge_scale: 0.75,
			/**
			 * 结束放大时的缩放值
			 */
			end_enlarge_scale: 2,
			/**
			 * 放大的时间(毫秒)
			 */
			enlarge_scale_time: 50,

			/**
			 * 开始缩小时的缩放值
			 */
			start_narrow_scale: 2,
			/**
			 * 结束缩小时的缩放值
			 */
			end_narrow_scale: 1,
			/**
			 * 缩小的时间(毫秒)
			 */
			narrow_scale_time: 150,
			/**
			 * 停留的时间(毫秒)
			 */
			stay_time: 550,
			/**
			* 结束开始的透明度
			*/
			start_alpha: 1,
			/**
			 * 结束的透明度
			 */
			end_alpha: 0,
			/**
			 * 透明度变化的时间(毫秒)
			 */
			alpha_time: 200,

			/**
			 * 分层处理 每层数量
			 */
			end_split_num: 3,

			/**
			 * 分层处理 每层偏移像素
			 */
			end_split_y: 100
		}
	}

	cache_fight_font_dic: {
		[key: string]: Array<FightFont>;
	} = {};
	now_show_font_dic = {};

	/**
	 * 每种动画类型的飘字缓存多少
	 */
	cache_count = 10
	layer_dic = {}

	constructor() {
		this.InitLayer()
		this.InitCacheDic();
		this.InitNowShowDic();
	}

	InitLayer = () => {
		let name_board_layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.DamageFont)
		for (let key in FightFontLayerType) {
			if (!isNaN(Number(key))) {
				var node = new Laya.Sprite()
				name_board_layer.addChild(node)
				this.layer_dic[key] = node
			}
		}
	}

	GetLayer = (layer: FightFontLayerType): Laya.Sprite => {
		return this.layer_dic[layer]
	}

	InitCacheDic = () => {
		for (let key in FightFontAniType) {
			if (!isNaN(Number(key))) {
				this.cache_fight_font_dic[key] = [];
			}
		}
	};

	ClearFontCache = () => {
		for (let key in FightFontAniType) {
			if (!isNaN(Number(key))) {
				let list = this.cache_fight_font_dic[key];
				if (list && list.length > this.cache_count) {
					let count = list.length - this.cache_count;
					while (count > 0) {
						let font = list.pop();
						if (font) {
							font.DeleteMe();
						}
						count--;
					}
				}
			}
		}
	};

	InitNowShowDic = () => {
		for (let key in FightFontAniType) {
			if (!isNaN(Number(key))) {
				this.now_show_font_dic[key] = {};
			}
		}
	};

	ClearNowShowFontDic = () => {
		for (let key in this.now_show_font_dic) {
			for (let hash_code in this.now_show_font_dic[key]) {
				this.now_show_font_dic[key][hash_code].DeleteMe();
			}
			this.now_show_font_dic[key] = {};
		}
	};

	/**
	 * 
	 * @param font_data 飘字数据
	 * @param str 内容
	 * @param attacker_pos 攻击者坐标
	 * @param defender_pos 防守者坐标
	 * @param attacker_dir 攻击者朝向
	 * @param defender_dir 防守者朝向
	 * @param attacker_body_height 攻击者身体高度
	 * @param defender_body_height 防守者身体高度
	 * @returns 
	 */
	public ShowFont = (font_data: IFightFontData, str: string, attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) => {
		if (!this.fight_font_2_res_name[font_data.font_type]) {
			return;
		}

		let list = this.cache_fight_font_dic[font_data.ani_type];
		let font: FightFont
		if (list.length == 0) {
			let font_name = this.GetFontClassName(font_data.ani_type);
			let sub_class = window[font_name]
			if (sub_class) {
				font = new sub_class();
			}
		}
		else {
			font = list.shift();
		}
		font.ShowText(font_data, str, attacker_pos, defender_pos, attacker_dir, defender_dir, attacker_body_height, defender_body_height);
		this.now_show_font_dic[font_data.ani_type][font.hashCode] = font;
	};

	/**
	 * 
	 * @param font_data 飘字数据
	 * @param url 内容
	 * @param attacker_pos 攻击者坐标
	 * @param defender_pos 防守者坐标
	 * @param attacker_dir 攻击者朝向
	 * @param defender_dir 防守者朝向
	 * @param attacker_body_height 攻击者身体高度
	 * @param defender_body_height 防守者身体高度
	 * @returns 
	 */
	public ShowImg = (font_data: IFightFontData, url: string, attacker_pos: Vector2, defender_pos: Vector2, attacker_dir: Vector2, defender_dir: Vector2, attacker_body_height: number, defender_body_height: number) => {
		let list = this.cache_fight_font_dic[font_data.ani_type];
		let font: FightFont
		if (list.length == 0) {
			let font_name = this.GetFontClassName(font_data.ani_type);
			let sub_class = window[font_name]
			if (sub_class) {
				font = new sub_class();
			}
		}
		else {
			font = list.shift();
		}
		if (font.ShowImg) {
			font.ShowImg(font_data, url, attacker_pos, defender_pos, attacker_dir, defender_dir, attacker_body_height, defender_body_height);
		}
		this.now_show_font_dic[font_data.ani_type][font.hashCode] = font;
	};

	public PushFont = <F extends FightFont>(font: F) => {
		let ani_type = font.GetFontAniType();
		let list = this.cache_fight_font_dic[ani_type];
		if (!font.TextObjIsNull() || !font.ImgObjIsNull()) {
			font.Reset();
			list.push(font);
		}
		delete this.now_show_font_dic[ani_type][font.hashCode];
	};

	public GetFontClassName(ani_type: FightFontAniType) {
		switch (ani_type) {
			case local_FightFontAniType.One:
				return "FightFontOneAni"
			case local_FightFontAniType.Two:
				return "FightFontTwoAni"
			case local_FightFontAniType.Three:
				return "FightFontThreeAni"
			case local_FightFontAniType.Four:
				return "FightFontFourAni"
			case local_FightFontAniType.Five:
				return "FightFontFiveAni"

		}
	}

	/**
	 * 
	 * @param type 飘字类型
	 * @param defender_pos 受击者位置
	 * @returns 
	 */
	public GetTweeningFontNum(type, defender_pos) {
		if (!defender_pos) return 0
		let count = 0
		let obj_ = this.now_show_font_dic[type]
		for (let key in obj_) {
			let vfont_vo = obj_[key]
			if (vfont_vo && vfont_vo.defender_pos_record
				&& vfont_vo.defender_pos_record.x == defender_pos.x
				&& vfont_vo.defender_pos_record.y == defender_pos.y
				) {
				count++
			}
		}
		return count
	}

	/**
	 * 
	 * @param type 飘字类型
	 * @returns 
	 */
	 public GetTweeningFontNum2(type) {
		return Util.TableSize(this.now_show_font_dic[type])
	}
}
window["FightFontManager"] = FightFontManager