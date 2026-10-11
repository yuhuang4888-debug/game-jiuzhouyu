import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SeaFightGuildItem } from "./SeaFightGuildItem"
import { SeaFightTotalItem } from "./SeaFightTotalItem"

export class SeaFightTotalView extends BaseView1 {
    InitView
    tabList
    dataGp
    cur_index = 0
    is_frist
    public constructor() {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaFightTotalView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_frist=false
        let local_modelIns = SeaHegemonyModel.GetInstance()
        this.load_callback = () => {
            this.InitView()
            local_modelIns.Fire(SeaHegemonyModel.REQUEST_PROTO, 18611)
        }

        this.InitView = () => {
            this.BindEvent(local_modelIns, SeaHegemonyModel.TOTAL_INFO, () => {
                let score_rank = local_modelIns.fightGuildData
                let showList=[]
                // score_rank:array{
                //     guild_id:int64        // 公会id/阵营id
                //     guild_name:string     // 公会名/阵营名
                //     is_att:int8           // 1进攻方 2防守方
                //     guild_rank:int8       // 排名
                //     guild_score:int16     // 积分
                //     member:array{
                //         rank:int16        // 公会内部排名
                //         role_id:int64     // 玩家id
                //         role_name:string  // 玩家名
                //         kill_score:int16  // 击杀积分
                //         score:int16       // 积分
                //     }
                // }


                table.sort(score_rank, (a?, b?) => {
                    if (a.guild_rank != b.guild_rank) {
                        return a.guild_rank < b.guild_rank
                    }
                    return false
                }
                )

                if (score_rank && score_rank.length > 0) {
                    if (!this.tabList) {
                        this.tabList = new LoopScrowViewMgr(this.layer_value)
                        this.tabList.SetData(this.tab_content, SeaFightGuildItem, score_rank, LoopScrCon.Horizontal, 1, (index?) => {
                            showList = score_rank[index] && score_rank[index].member
                            if (showList) {
                                table.sort(showList, (a?, b?) => {
                                    if (a.rank != b.rank) {
                                        return a.rank < b.rank
                                    }
                                    return false
                                }
                                )
                                if(!this.dataGp){
                                    this.dataGp = new LoopScrowViewMgr(this.layer_value)
                                    this.dataGp.SetData(this.Content, SeaFightTotalItem, showList, LoopScrCon.Vertical)
                                }else{
                                    this.dataGp.replaceAll(showList)
                                }
                                
                            }
                        })
                    } else {
                        this.tabList.replaceAll(score_rank)
                    }

                    if(!this.is_frist){
                        let main_vo = RoleManager.Instance.mainRoleInfo
                        let default_id=0
                        let camp_id
                        if(SeaHegemonyModel.GetInstance().actType==2){
                            camp_id = main_vo.camp
                        }else{
                            camp_id = main_vo.guild_id
                        }
                        for(let i=0;i<score_rank.length;i++){
                            if(score_rank[i].guild_id==camp_id){
                                default_id = i
                                break
                            }
                        }

                        this.tabList.SetSelectIndex(default_id)
                        this.is_frist=true
                    }
                    
                }
            },true
            
            )
            Util.AddClickEvent(this.closeBtn, () => {
                    this.Close()
             },this,true)
        }


        this.destroy_callback = () => {
            this.is_frist=false
            if (this.dataGp) {
                this.dataGp.DeleteMe()
                this.dataGp = null
            }
            if (this.tabList) {
                this.tabList.DeleteMe()
                this.tabList = null
            }
        }
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }


    bg: Laya.Image
    _Image2_title: Laya.Image
    _lb_win_name: Laya.Label
    closeBtn: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Image7: Laya.Image
    Content: Laya.List
    _Label1: Laya.Label
    _Label2: Laya.Label
    _Label3: Laya.Label
    _Label4: Laya.Label
    tab_content: Laya.List
    public GetComponents() {
        [
            this.bg,
            this._Image2_title,
            this._lb_win_name,
            this.closeBtn,
            this._Image2,
            this._Image3,
            this._Image4,
            this._Image5,
            this._Image7,
            this.Content,
            this._Label1,
            this._Label2,
            this._Label3,
            this._Label4,
            this.tab_content,
        ]
            = this.GetChildrenByNames([

                "bg",
                "_Image2_title",
                "_lb_win_name",
                "closeBtn",
                "_Image2",
                "_Image3",
                "_Image4",
                "_Image5",
                "_Image7",
                "Content",
                "_Label1",
                "_Label2",
                "_Label3",
                "_Label4",
                "tab_content",
            ])
    }
}
window["SeaFightTotalView"] = SeaFightTotalView