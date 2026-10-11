import { ResManager } from '../common/ResManager';
import { GuildEvent } from '../commonModel/GuildModel';
import { Util } from '../util/Util';
import { GuildSkillShowItem } from './GuildSkillShowItem';

export class GuildSkillZItem extends GuildSkillShowItem {
    cfg;

    public constructor(parent?) {
        super(parent);

        //this.preload_server_config = [Guildskill=false, Guildskillresearch=false]
        this.load_callback = () => {
            // this.GetComponents()
            this.InitEvent();
        };
    }

    public InitEvent() {
        this.BindEvent(this.model, GuildEvent.SELECT_SKILL_ITEM, (data?, cfg?) => {
            this.Select(this.cfg.skill_id == cfg.skill_id);
        });
        Util.AddClickEvent(
            this._img_icon,
            () => {
                this.model.Fire(GuildEvent.SELECT_SKILL_ITEM, this.data, this.cfg);
            },
            this
        );
    }

    public SetData(data?) {
        super.SetData(data);
        let guild_skill_research_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_guild_skill_research', false);
        let Guildskill = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_guild_skill', false);
        this._reddot.visible = this.model.CheckSkillRedDotOne(data, guild_skill_research_cfg, Guildskill);
    }

    public SetDefault(cfg?) {
        this.cfg = cfg;
    }

    public Select(visible?) {
        this._img_select.visible = visible;
    }
}

window['GuildSkillZItem'] = GuildSkillZItem;
