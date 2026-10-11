import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetAnchoredPosition, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { ElimChessDisplay } from "./ElimChessDisplay"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"
import { ElimUtil } from "./ElimUtil"


/**棋盘格子界面   类似棋盘上的方格，落子的时候会加载旗子，起子则会删除棋子*/
export class ElimBlockDisplay extends BaseItem1 {
    buff_type
    buff_value
    chess_type
    chess_item: ElimChessDisplay
    is_load_chess
    is_move
    move_tween_id
    need_refresh_data
    on_load_callback
    shake_tween_id
    shake_tween_id2
    shake_tween_id3
    shake_tween_id4
    tweens
    x
    y
    remove_time

    ELIM_UNIT_SPD = ElimDefine.ELIM_UNIT_SPD
    ELIM_SWAP_SPD = ElimDefine.ELIM_SWAP_SPD
    ActionWave2Spd = ElimDefine.ActionWave2Spd

    public constructor(parent) {
        super(parent)

        this.base_file = "elim"
        this.layout_file = "ElimBlockDisplay"
        this.layer_value = Enum_UILayer.UI
        this.tweens = []
        this.is_move = false

        this.load_callback = () => {
            this.LoadSuccess()
        }
    }

    public LoadSuccess() {


        this.InitEvent()

        if (this.x && this.y && this.display_obj) {
            this.display_obj.name = this.x + '_' + this.y
        }
        if (this.is_load_chess) {
            this.is_load_chess = null
            this.LoadChess(this.chess_type, this.x, this.y, this.buff_type, this.buff_value, this.on_load_callback)
            this.on_load_callback = null


            this.buff_name.text = ""//`${this.x}_${this.y}`
        }

    }

    public InitEvent() {

        if (this.need_refresh_data) {
            //this.UpdateItem()
            this.need_refresh_data = null
        }


        this.BindEvent(ElimGameMgr.GetInstance(), ElimDefine.ElimEvent.CHANGE_CHESS_BUFF_TYPE, (x, y, buff_type, chess_type?) => {
            if (this.x == x && this.y == y) {
                this.buff_type = buff_type
                if(buff_type==4){
                    chess_type = 6
                }
                if(!chess_type){
                    chess_type = this.chess_type
                }
                this.chess_item.SetChessData(chess_type, buff_type, this.buff_value, this.x, this.y)
                this.chess_item.SetBuff(buff_type)
            }
        })


        this.BindEvent(ElimGameMgr.GetInstance(), ElimDefine.ElimEvent.CHUNK_CHESS_WAIT_DEAL, (x, y) => {
            if (this.x == x && this.y == y) {
                this.chess_item.ScaleBig()
            }
        })

    }

    public LoadChess(chess_type?, x?, y?, buff_type?, buff_value?, load_callback?) {
        this.chess_type = chess_type
        this.buff_type = buff_type
        this.buff_value = buff_value
        this.on_load_callback = load_callback
        this.x = (x || x == 0) ? x : this.x
        this.y = (y || y == 0) ? y : this.y
        if (this.is_loaded) {
            if (!this.chess_item) {
                this.chess_item = new ElimChessDisplay(this.con_chess)
                this.chess_item.Load()
            }

            this.chess_item.SetChessData(chess_type, buff_type, buff_value, this.x, this.y)
            this.chess_item.SetLoadCallback(load_callback)
            this.on_load_callback = null

        } else {
            this.is_load_chess = true
        }
    }

    public RemoveChess() {

        this.ClearUIEffect(this.effect_gp)
        this.AddUIEffect("effect_popgame_spark", this.effect_gp, { x: 0, y: 0 }, 4, false, null, null, null, this, false, null, LOAD_QUEUE.LOW, false)
        if (this.chess_item) {
            this.chess_item.DeleteMe()
            this.chess_item = null
        }

    }

    public PlayMoveAnim(pos?, need_back?, move_callback?) {

        if (this.shake_tween_id) {
            SYTweenLite.Stop(this.shake_tween_id)
            this.shake_tween_id = null
        }

        if (this.shake_tween_id3) {
            SYTweenLite.Stop(this.shake_tween_id3)
            this.shake_tween_id3 = null
        }

        if (this.shake_tween_id4) {
            SYTweenLite.Stop(this.shake_tween_id4)
            this.shake_tween_id4 = null
        }

        if (!this.chess_item) {
            if (move_callback) {
                move_callback()
            }
            return
        }
        this.is_move = true
        let [t_pos_x, t_pos_y] = ElimUtil.TransformTargetPos(this.x, this.y, pos[0], pos[1])
        this.shake_tween_id3 = SYTweenLite.to(this, this.con_chess, SYTweenLite.UiAnimationType.POS, new Vector3(t_pos_x, t_pos_y, 0), this.ELIM_SWAP_SPD, () => {
            if (need_back) {
                this.shake_tween_id4= SYTweenLite.to(this, this.con_chess, SYTweenLite.UiAnimationType.POS, Vector3.zero, this.ELIM_SWAP_SPD, () => {
                    if (move_callback) {
                        move_callback()
                    }
                    this.is_move = false
                })
                table.insert(this.tweens,  this.shake_tween_id4)
            } else {
                if (move_callback) {
                    move_callback()
                }
                this.is_move = false
            }
        })
        table.insert(this.tweens,  this.shake_tween_id3)
    }

    public PlayShake() {

        if (this.shake_tween_id) {
            SYTweenLite.Stop(this.shake_tween_id)
            this.shake_tween_id = null
        }
        this.shake_tween_id = SYTweenLite.to(this, this.con_chess, SYTweenLite.UiAnimationType.ANCHORED_POSY, 2, 0.5, null, SYTweenFunc.PINGPONG, true)
        table.insert(this.tweens, this.shake_tween_id)
    }

    public ReplaceChess(chess_item?) {

        let old_chess = this.chess_item
        this.SetChessItem(chess_item)
        return old_chess
    }

    public SetChessItem(chess_item: ElimChessDisplay) {

        if (chess_item) {
            this.con_chess.addChild(chess_item.display_obj)
            SetAnchoredPosition(chess_item.display_obj, 0, 0)
            this.chess_type = chess_item.chess_type
        }
        this.chess_item = chess_item
    }

    /*
        将棋子设置到对应的逻辑坐标
    */
    public SetAnchoredPosByLogicPos(logic_x?, logic_y?) {

        let [t_pos_x, t_pos_y] = ElimUtil.TransformTargetPos(this.x, this.y, logic_x, logic_y)
        this.SetConChessAnPos(t_pos_x, t_pos_y)
    }

    public SetConChessAnPos(x?, y?) {

        SetAnchoredPosition(this.con_chess, x, y)
    }

    public CalcSpd = (action_wave) => {
        //使用固定的生成间隔 避免特效播放异常
        //异常表现为，特效会先播放，过了N久之后才消除
        return 0.3  

        // let spd = this.ActionWave2Spd[action_wave]
        // if (!spd) {
        //     if (action_wave > Util.TableSize(this.ActionWave2Spd)) {
        //         spd = this.ActionWave2Spd[Util.TableSize(this.ActionWave2Spd) - 1]
        //     }
        // }
        // return spd
    }
    /*
        
    */
    public Back(action_wave?, callback?, immediate?) {

        if (!this.con_chess) {
            return 0
        }
        if (this.shake_tween_id) {
            SYTweenLite.Stop(this.shake_tween_id)
            this.shake_tween_id = null
        }

        if (this.shake_tween_id2) {
            SYTweenLite.Stop(this.shake_tween_id2)
            this.shake_tween_id2 = null
        }


        if (immediate) {
            this.SetConChessAnPos(0, 0)
            if (callback) {
                callback()
            }
        } else {
            this.is_move = true
            action_wave = action_wave || 0
            let spd = this.CalcSpd(action_wave)
            this.shake_tween_id2 = SYTweenLite.to(this, this.con_chess, SYTweenLite.UiAnimationType.POS, Vector3.zero, spd, () => {
                if (callback) {
                    callback()
                }
                this.is_move = false

                ElimGameMgr.GetInstance().current_move_num--
                if(ElimGameMgr.GetInstance().current_move_num<=0){
                   ElimGameMgr.GetInstance().Fire(ElimDefine.ElimEvent.ALL_CHESS_FALL_IN_OVER)
                }
            })
            table.insert(this.tweens, this.shake_tween_id2)
            return spd
        }
        return 0
    }

    public SetNewPos(x?, y?, need_move?, immediate?, callback?) {
        this.x = x
        this.y = y

        if (this.x && this.y && this.display_obj) {
            this.display_obj.name = this.x + '_' + this.y
        }

        if (need_move) {
            if (!this.display_obj) {
                return
            }
            let [pos_x, pos_y] = ElimUtil.GetAnchoredPos(x, y)
            if (this.move_tween_id) {
                SYTweenLite.Stop(this.move_tween_id)
                this.move_tween_id = null
            }
            if (immediate) {
                this.SetPosition(pos_x, pos_y)
                if (callback) {
                    callback()
                }
            } else {
                this.move_tween_id = SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.POS, new Vector3(pos_x, pos_y, 0), this.ELIM_UNIT_SPD, () => {
                    if (callback) {
                        callback()
                    }
                })
                table.insert(this.tweens, this.move_tween_id)
            }
        }
    }

    public GetChess() {

        return this.chess_item
    }

    public DeleteMe() {

        if (this.tweens) {
            for (let _ in this.tweens) {
                var id = this.tweens[_]
                SYTweenLite.Stop(id)
            }
        }
        this.tweens = []

        if (this.chess_item) {
            this.chess_item.DeleteMe()
            this.chess_item = null
        }
        this.on_load_callback = null
        this.ClearUIEffect(this.effect_gp)
        super.DeleteMe()
    }



con_chess:Laya.Box
effect_gp:Laya.Box
buff_name:Laya.Label
public GetComponents() {
[
this.con_chess,
this.effect_gp,
this.buff_name,
]
 = this.GetChildrenByNames([

"con_chess",
"effect_gp",
"buff_name",
])
}
}
 window["ElimBlockDisplay"]= ElimBlockDisplay