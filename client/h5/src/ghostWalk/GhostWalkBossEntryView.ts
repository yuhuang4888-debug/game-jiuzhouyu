import { Util } from '../util/Util';
import { GhostWalkModel, GhostWalkEvent } from '../commonModel/GhostWalkModel';
import { Enum_UILayer } from '../common/LayerManager';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventName } from '../common/EventName';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { EquipmentItem } from '../common/EquipmentItem';
import { BaseView1 } from '../common/BaseView1';
import { GhostWalkBossEntryItem } from './GhostWalkBossEntryItem';
import { ResManager } from '../common/ResManager';
import { GameResPath } from '../util/GameResPath';
import { SceneManager } from '../scene/SceneManager';
export class GhostWalkBossEntryView extends BaseView1 {
    loop_mgr: LoopScrowViewMgr;
    lastRewardItem: EquipmentItem;
    private model: GhostWalkModel;
    cfg;
    public constructor() {
        super();
        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkBossEntryView';
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        this.show_open_movie = true;
        this.change_scene_close = true;
        this.model = GhostWalkModel.ins;
        this.preload_server_config = {
            config_mon: false,
            config_scene: false
        };

        this.load_callback = () => {
            this.initEvent();
        };

        this.open_callback = this.initView;
    }

    private initView() {
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.imgLine,
            GameResPath.GetIconOtherPath('ghostWalk', 'com_line_5')
        );
        this.model.Fire(GhostWalkEvent.SendFmt20602, 0);
    }

    private initEvent() {
        this.BindEvent(this.model, GhostWalkEvent.RecvFmt20602, this.updateBossList.bind(this));
        this.BindEvent(this.model, GhostWalkEvent.GO_POINT, (_, fromChild) => {
            // 在场景中打开界面点击寻路后要关闭界面
            if (fromChild && SceneManager.GetInstance().IsGhostWalkScene()) {
                this.Close();
            }
        });
        Util.AddClickEvent(this.btnClose, this.Close.bind(this), this, true);
        Util.AddClickEvent(
            this.btnReward,
            () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GhostWalkRewardView');
            },
            this,
            true
        );
    }

    async updateBossList(vo: ProtoRecvVObj<20602>) {
        let bossList = this.model.getBossList(vo);
        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.listBoss,
                GhostWalkBossEntryItem,
                bossList,
                LoopScrCon.Vertical
            );
        } else {
            this.loop_mgr.replaceAll(bossList);
        }
    }

    public DeleteMe() {
        super.DeleteMe();
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
    }

    imgLine: Laya.Image;
    btnClose: Laya.Image;
    btnReward: Laya.Image;
    listBoss: Laya.List;
    public GetComponents() {
        [this.imgLine, this.btnClose, this.btnReward, this.listBoss] = this.GetChildrenByNames([
            'imgLine',
            'btnClose',
            'btnReward',
            'listBoss'
        ]);
    }
}
window['GhostWalkBossEntryView'] = GhostWalkBossEntryView;
