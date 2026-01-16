from pydantic import BaseModel, Field
from typing import List, Optional


class ContentThemeInsight(BaseModel):
    theme: str
    performance_level: str  # e.g. "high", "medium", "low"
    reasoning: str
    recommendation: str


class EngagementInsight(BaseModel):
    type: str  # e.g. "authenticity", "comments", "likes"
    analysis: str
    recommendation: Optional[str]


class StrategicRecommendation(BaseModel):
    area: str
    insight: str
    action: str


class GrowthForecast(BaseModel):
    expected_growth_percent: float
    confidence_level: str
    reasoning: str


class BehavioralForecast(BaseModel):
    virality_likelihood: str
    engagement_decay_warning: bool
    conversion_forecast: str


class DemographicInsight(BaseModel):
    key_observations: str
    audience_alignment: str
    growth_opportunities: str
    risk_factors: Optional[str] = None


class MarketingInsightsReport(BaseModel):
    account_overview: str
    audience_insights: str
    demographic_insights: Optional[DemographicInsight]
    content_performance: List[ContentThemeInsight]
    engagement_quality: List[EngagementInsight]
    growth_forecast: GrowthForecast
    behavioral_forecast: BehavioralForecast
    strategic_recommendations: List[StrategicRecommendation]
    summary_narrative: str

    def to_json(self) -> str:
        return self.model_dump_json()
