import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Config } from '../common/Config';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { IGhostWalkBossInfo } from '../commonModel/GhostWalkModel';
import { SceneManager } from '../scene/SceneManager';
import { GameResPath } from '../util/GameResPath';
import { GhostWalkBossEntryPoint } from './GhostWalkBossEntryPoint';

export class GhostWalkBossEntryItem extends BaseItemRenderer {
    need_refresh = false;
    argv: IGhostWalkBossInfo;
    WIDTH = 608;
    HEIGT = 242;
    loop_mgr: LoopScrowViewMgr;
    public constructor() {
        super();

        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkBossEntryItem';
        this.load_callback = () => {
            if (this.need_refresh) {
                this.need_refresh = false;
                this.updateItem.call(this, this.argv);
            }
        };
        this.Load();
    }

    public async updateItem(data: IGhostWalkBossInfo) {
        if (!this.is_loaded) {
            this.need_refresh = true;
            this.argv = data;
            return;
        }
        this.data = data;
        this.htmlLiveState.style.color = '#663915';
        this.htmlLiveState.style.fontSize = 24;
        this.htmlLiveState.style.wordWrap = false;
        this.htmlLiveState.innerHTML = '';
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.imgBg,
            GameResPath.GetIconOtherPath('ghostWalk', 'itemBg')
        );
        const monCfg = Config.GetConfigVo(
            Config.ConfigHasDefaultValue.config_mon.name,
            data.bossId,
            false
        );
        const sceneCfg = SceneManager.GetInstance().GetSceneInfo(data.sceneId);
        this.lblBossName.text = monCfg.name;
        this.htmlLiveState.innerHTML = `存活: <font color="${
            data.bossNum > 0 ? '#0a953e' : '#fe1a1a'
        }">${data.bossNum}</font>`;
        this.lblSceneName.text = sceneCfg.name;
        ResManager.GetInstance().SetOutsideImageSprite(
            this,
            this.imgBossIcon,
            GameResPath.GetMonsterHeadPath(monCfg.icon)
        );

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.listPoint,
                GhostWalkBossEntryPoint,
                data.appearPoint,
                LoopScrCon.Horizontal
            );
        } else {
            this.loop_mgr.replaceAll(data.appearPoint);
        }
    }

    public DeleteMe() {
        super.DeleteMe();
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
    }
    imgBg: Laya.Image;
    imgBossIcon: Laya.Image;
    lblBossName: Laya.Label;
    lblSceneName: Laya.Label;
    htmlLiveState: Laya.HTMLDivElement;
    listPoint: Laya.List;
    public GetComponents() {
        [
            this.imgBg,
            this.imgBossIcon,
            this.lblBossName,
            this.lblSceneName,
            this.htmlLiveState,
            this.listPoint
        ] = this.GetChildrenByNames([
            'imgBg',
            'imgBossIcon',
            'lblBossName',
            'lblSceneName',
            'htmlLiveState',
            'listPoint'
        ]);
    }
}
window['GhostWalkBossEntryItem'] = GhostWalkBossEntryItem;
