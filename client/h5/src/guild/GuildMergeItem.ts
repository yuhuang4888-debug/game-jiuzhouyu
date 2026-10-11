import { Alert, AlertConfig } from '../alert/Alert';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { ResManager } from '../common/ResManager';
import { GuildEvent, GuildModel, IGuildMergeInfo } from '../commonModel/GuildModel';
import { Message } from '../sysInfo/SysInfoController';
import { GameResPath } from '../util/GameResPath';
import { RefBoxVLayout, Util } from '../util/Util';

export class GuildMergeItem extends BaseItemRenderer {
    data: IGuildMergeInfo;
    WIDTH = 554;
    HEIGT = 120;
    model: GuildModel;
    constructor() {
        super();
        this.base_file = 'guild';
        this.layout_file = 'GuildMergeItem';
        this.model = GuildModel.GetInstance();
        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        };
        this.Load();
    }
    dataChanged() {
        if (!super.dataChanged()) return;
        let { guild_name, chief_name, member_num, combat_power, merge_status, tabIndex, guild_lv, isTop } = this.data;
        // 前三公会底图
        this.gTop.visible = !!isTop && tabIndex == 1;
        this.lblGuildName.text = guild_name;
        this.lblGuildLevel.text = `${guild_lv}级`;
        this.lblMaster.text = `会长：${chief_name}`;
        this.lblNum.text = `${member_num}`;
        this.lblScore.text = `${combat_power}`;
        // 请求界面不是已请求状态，或者互相请求的时候打开了申请界面，需要显示这个按钮
        this.btnMerge.visible = merge_status > 1 || merge_status == 1 && tabIndex == 2;
       // this.lblState.y = merge_status > 1 ? 99 : 60;
        this.lblState.visible = merge_status >= 1 && tabIndex == 1;
        let lblState = '';
        switch (merge_status) {
            case 1:
                lblState = '已请求';
                break;
            case 2:
                lblState = '可合并';
                break;
            case 3:
                lblState = '结社人数过多无法合并';
                break;
        }
        this.lblState.text = lblState;
        this.lblMerge.text = `${tabIndex == 1 ? '请求合并' : '合并此结社'}`;
        this.btnRefuse.visible = tabIndex == 2;
        RefBoxVLayout(this.btnBox, 10, true, true);
        this.btnBox.y=(this.display_obj.height-this.btnBox.height)/2
    }
    DeleteMe() {
        super.DeleteMe();
    }
    private LoadSuccess() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this.imgTop, GameResPath.GetIconOtherPath('guild', 'ui_Guild_45'));
    }
    private InitEvent() {
        Util.AddClickEvent(this.btnMerge, ()=>{
            this.OnClick(true)
        }, this, true);
        Util.AddClickEvent(this.btnRefuse, ()=>{
            this.OnClick(false)
        }, this, true);
    }
    private OnClick(agree: boolean) {
        if (!this.data) return;
        let { guild_id, merge_status, tabIndex, is_master } = this.data;
        if (merge_status == 3) {
            Message.show('结社人数过多无法合并');
        } else {
            if (tabIndex == 1) {
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40062, 'l', guild_id);
            } else {
                if (!agree) {
                    this.model.Fire(GuildEvent.REQUEST_40063, 'cl', 2, guild_id);
                } else {
                    let config = new AlertConfig();
                    config.show_content = is_master == 1 ? '合并后本结社玩家将会并入对方结社，<br>本结社将会解散，结社资源不会保留,<br>是否并入该结社？' : '合并后对方结社玩家将会并入本结社，<br>对方结社资源不会合并，<br>是否合并该结社？';
                    config.ok_callback = () => {
                        this.model.Fire(GuildEvent.REQUEST_40063, 'cl', 1, guild_id);
                    };
                    Alert.ShowWithConfig(config);
                }
            }
        }
    }


    gTop: Laya.Box
    imgTop: Laya.Image
    btnBox: Laya.Box
    btnMerge: Laya.Image
    lblMerge: Laya.Label
    btnRefuse: Laya.Image
    lblRefuse: Laya.Label
    lblState: Laya.Label
    lblGuildName: Laya.Label
    lblGuildLevel: Laya.Label
    lblMaster: Laya.Label
    lblNum: Laya.Label
    lblScore: Laya.Label
    public GetComponents() {
        [
            this.gTop,
            this.imgTop,
            this.btnBox,
            this.btnMerge,
            this.lblMerge,
            this.btnRefuse,
            this.lblRefuse,
            this.lblState,
            this.lblGuildName,
            this.lblGuildLevel,
            this.lblMaster,
            this.lblNum,
            this.lblScore,
        ]
            = this.GetChildrenByNames([

                "gTop",
                "imgTop",
                "btnBox",
                "btnMerge",
                "lblMerge",
                "btnRefuse",
                "lblRefuse",
                "lblState",
                "lblGuildName",
                "lblGuildLevel",
                "lblMaster",
                "lblNum",
                "lblScore",
            ])
    }
}
window["GuildMergeItem"] = GuildMergeItem