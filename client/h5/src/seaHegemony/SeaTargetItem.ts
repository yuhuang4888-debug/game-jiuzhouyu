
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Scene } from "../scene/Scene"
import { MonsterType, SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, GetSizeDeltaX, Util, TransformLevel, Trim } from "../util/Util"
import { Config } from "../common/Config"
import { BaseItem1 } from "../common/BaseItem1"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { DressModel } from "../commonModel/DressModel"

export class SeaTargetItem extends BaseItem1 {
    time
    model
    data
    index
    need_fresh
    UpdateHpState
    timer2
    updateTimer
    SetSeaType
    is_attack
    effect
    ShowAttackEffect
    lastBossId
    boss_scene_mgr
    head1
    circle_mask
    public constructor(parent) {
        super(parent)

        this.time = 0
        this.model = SeaHegemonyModel.GetInstance()
        this.boss_scene_mgr = BossSceneManager.GetInstance()
        this.base_file = "seaHegemony"
        this.layout_file = "SeaTargetItem"
        this.need_fresh = false
        this.load_callback = () => {
            this.InitEvent()
            if (this.need_fresh) {
                this.need_fresh = false
                this.dataChanged()
            }
        }

        this.UpdateHpState = (vo?) => {
            let canAttack = SceneManager.GetInstance().IsCanAttackByMainRole(vo,false,false,false) || SeaHegemonyModel.GetInstance().CanAttackRole(vo)
            if (canAttack) {
                if (this.model.fightType == 0) {
                    if(vo.type == MonsterType.COLLECT)canAttack = false
                }
            }

            if (canAttack) {
                ResManager.GetInstance().SetImageSprite(this, this._progress_bar, this.base_file, "uizdpz_016a")
            } else {
                ResManager.GetInstance().SetImageSprite(this, this._progress_bar, this.base_file, "uizdpz_016")
            }
        }

        this.updateTimer = () => {
            this.time = this.time - 1
            this._count_lb.text = TimeUtil.convertTime(this.time)
            if (this.time < 0) {
                GlobalTimerQuest.CancelQuest(this.timer2)
                this.timer2 = null
                this._count_lb.visible = false
                this._progress_gp.visible = true
            }
        }

        this.SetSeaType = (type?) => {
            let sp_name
            if (type == 1) {
                sp_name = "sea01"
                this.seaTypeLb.text = "战列"
            } else {
                sp_name = "sea02"
                this.seaTypeLb.text = "攻城"
            }
            ResManager.GetInstance().SetImageSprite(this, this.seaTypeImg, "seaHegemony", sp_name, true)
        }

        this.is_attack = false
        this.ShowAttackEffect = (value?) => {
            if (value) {
                if (!this.effect) {
                    this.effect = true
                }

                if (!this.is_attack) {
                    this.is_attack = true
                    this.AddUIEffect("UI_2017", this._attack_effect_gp, { x: 0, y: 0 }, 12, true)
                }

            } else {
                if (this.is_attack) {
                    this.is_attack = false
                    if (this.effect) {
                        this.ClearUIEffect(this._attack_effect_gp)
                        this.effect = false
                    }
                }
            }
        }

    }

    public InitEvent() {
        this.InitMask()
        Util.AddClickEvent(this._gp_child, () => {
            this.model.Fire(SeaHegemonyModel.CHOSE_TARGET, this.data)
        }, this, true)

		this.BindEvent(GlobalEventSystem, EventName.MAIN_ROLE_CHANGE_ATTACK_TARGRT, (monster?) => {
            let boo=false
            if(this.data&&monster){
                boo=this.data == monster.GetVo() && !monster.is_dead
            }
            this.ShowAttackEffect(boo)
        }
        )
        
    }

    public SetData(data?, index?) {
        this.data = data
        this.index = index
        if (!this.is_loaded) {
            this.need_fresh = true
            return
        }
        this.dataChanged()
    }

    public InitMask() {
        this.circle_mask = new Laya.Sprite()
        this.circle_mask.x = this._progress_bar.width / 2
        this.circle_mask.y = this._progress_bar.height / 2
        this._progress_bar.mask = this.circle_mask
    }

    public DrawMaskCircle(angle) {
        angle = 1 - angle
        let value = 90
        this.circle_mask.graphics.clear();
        this.circle_mask.graphics.drawPie(0, 0, 50, value, 360 + value - angle * 360, 0x000000)
    }


    public dataChanged() {
        this._head_img.visible=false
        if (this.timer2) {
            GlobalTimerQuest.CancelQuest(this.timer2)
            this.timer2 = null
            this.time = 0
        }

        if (this.head1) {
            this.head1.SetVisible(false)
        }
        let vo = this.data
        let showLock = false
        if (!vo.vo_type) {
            let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.bossid, false)
            this._name_lb.text = bossVo.name
            this._lv_lb.text = ""
            this._progress_gp.visible = false
            this._count_lb.visible = true
            if (this.lastBossId != vo.bossid) {
                this.time = Mathf.Max(vo.reborn_time - TimeUtil.getServerTime(), 0)
            } else {
                // [ts2lua]lua中0和空字符串也是true，此处this.time > 0需要确认
                this.time = (this.time > 0 && (this.time) || (Mathf.Max(vo.reborn_time - TimeUtil.getServerTime(), 0)))
            }
            this._count_lb.text = TimeUtil.convertTime(this.time)
            if (!this.timer2) {
                this.timer2 = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.updateTimer()
                }, 1)
            }
            //this:showSufferedEffect(false)
            let icon = bossVo && bossVo.icon
            if (icon) {
                this._head_img.visible=true
                ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, `resource/game/monsterHead/${bossVo.icon}.png`)
            }
            this.lastBossId = vo.bossid
            this._gp_attribution.visible = false
            this.seaTypeGp.visible = false
        }
        else if (vo.vo_type == SceneBaseType.Monster) {
            this._name_lb.text = vo.name
            this._lv_lb.text = ""
            this.DrawMaskCircle(vo.hp / vo.maxHp)
            this._count_lb.visible = false
            this._progress_gp.visible = true
            this.UpdateHpState(vo)
            if (vo.cfg_data) {
                this._head_img.visible=true
                ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img,  `resource/game/monsterHead/${vo.cfg_data.icon}.png`)
            }
            //this:showSufferedEffect(! this.is_attack && this.secret.isSuffered(vo.instance_id))
            this._gp_attribution.visible = false
            this.seaTypeGp.visible = false
        }
        else if (vo.vo_type == SceneBaseType.Role) {
            this._gp_attribution.visible = vo.boss_flag == 1
            this._name_lb.text = vo.name
            this._lv_lb.text = TransformLevel(vo.level)
            this._count_lb.visible = false
            this._progress_gp.visible = true
            this.DrawMaskCircle(vo.hp / vo.maxHp)
            let is_mask = vo.mask_id != 0 && SceneManager.GetInstance().CanMaskScene()

            if (this.head1 == null) {
				this.head1 = new CustomHeadItem(this._head)
				this.head1.SetActiveFrame(false)
				this.head1.SetActiveLevel(false)
				this.head1.SetActiveBg(false)

				this.head1.CloseClick()
				this.head1.SetScale(0.8)
				this.head1.Load()
			}
			this.head1.SetActiveBg(false)
			this.head1.SetRoleVoData(is_mask && { career: vo.career } || vo)
			this.head1.SetActiveBg2(false)
            this.head1.SetVisible(true)

            this._head_img.visible=false

            this.UpdateHpState(vo)
            this.seaTypeGp.visible = true
            this.SetSeaType(vo.warGroup)
        }
        else if (vo.vo_type == SceneBaseType.MainRole) {
            this._gp_attribution.visible = vo.boss_flag == 1
            this._name_lb.text = vo.name
            this._lv_lb.text = "神创" + (vo.level - 370)
            this._count_lb.visible = false
            this._progress_gp.visible = true

            //头像
            let picture_source = DressModel.GetInstance().getHeadICon(91, vo.career)
            let picture_id = vo.picture
            if (picture_id && Trim(String(picture_id)) != "") {
                picture_source = DressModel.GetInstance().getHeadICon(picture_id, vo.career)
            }
            this._head_img.visible=false
            ResManager.GetInstance().SetImageSpriteTrans(this, this._head_img, GameResPath.GetIcon("head", picture_source))

            this.UpdateHpState(vo)
            this.seaTypeGp.visible = true
            this.SetSeaType(vo.warGroup)
        }

        let monster =Scene.GetInstance().GetClickTarget()
		if(monster){
			this.ShowAttackEffect((monster.GetVo()==this.data&&!monster.is_dead))
		}else{
			this.ShowAttackEffect(false)
		}
    }

    public DeleteMe() {

        if (this.circle_mask) {
            this.circle_mask.removeSelf()
            this.circle_mask.destroy()
            this.circle_mask = null
        }


        if (this.timer2) {
            GlobalTimerQuest.CancelQuest(this.timer2)
            this.timer2 = null
            this.time = 0
        }

        if (this.head1) {
            this.head1.DeleteMe()
            this.head1 = null
        }
        super.DeleteMe()
    }




    _gp_child: Laya.Box
    _Group1: Laya.Box
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Imag: Laya.Image
    _head_img: Laya.Image
    _head: Laya.Box
    _count_lb: Laya.Label
    _progress_gp: Laya.Box
    _progress_bar: Laya.Image
    _lv_lb: Laya.Label
    _name_lb: Laya.Label
    _gp_attribution: Laya.Image
    seaTypeGp: Laya.Box
    seaTypeImg: Laya.Image
    seaTypeLb: Laya.Label
    _attack_effect_gp: Laya.Box
    public GetComponents() {
        [
            this._gp_child,
            this._Group1,
            this._Image1,
            this._Image2,
            this._Imag,
            this._head_img,
            this._head,
            this._count_lb,
            this._progress_gp,
            this._progress_bar,
            this._lv_lb,
            this._name_lb,
            this._gp_attribution,
            this.seaTypeGp,
            this.seaTypeImg,
            this.seaTypeLb,
            this._attack_effect_gp,
        ]
            = this.GetChildrenByNames([

                "_gp_child",
                "_Group1",
                "_Image1",
                "_Image2",
                "_Imag",
                "_head_img",
                "_head",
                "_count_lb",
                "_progress_gp",
                "_progress_bar",
                "_lv_lb",
                "_name_lb",
                "_gp_attribution",
                "seaTypeGp",
                "seaTypeImg",
                "seaTypeLb",
                "_attack_effect_gp",
            ])
    }
}
window["SeaTargetItem"] = SeaTargetItem