"""
Platform enumeration for social media platforms
"""

from enum import Enum


class Platform(Enum):
    """Enumeration of supported social media platforms"""

    INSTAGRAM = "instagram"
    TIKTOK = "tiktok"
    YOUTUBE = "youtube"
    X = "X"
    LINKEDIN = "linkedin"
    FACEBOOK = "facebook"
    COMBINED_PLATFORMS = "combined_platforms"

    def __str__(self) -> str:
        return self.value

    @classmethod
    def from_string(cls, platform_str: str) -> "Platform":
        """
        Create Platform enum from string value

        Args:
            platform_str: String representation of platform

        Returns:
            Platform enum value

        Raises:
            ValueError: If platform string is not supported
        """
        platform_str = platform_str.lower().strip()
        for platform in cls:
            if platform.value == platform_str:
                return platform

        raise ValueError(f"Unsupported platform: {platform_str}")

    @classmethod
    def get_all_platforms(cls) -> list["Platform"]:
        """Get list of all supported platforms"""
        return list(cls)

    @property
    def domain(self) -> str:
        """Get the main domain for the platform"""
        domain_map = {
            Platform.INSTAGRAM: "instagram.com",
            Platform.TIKTOK: "tiktok.com",
            Platform.YOUTUBE: "youtube.com",
            Platform.X: "x.com",
            Platform.LINKEDIN: "linkedin.com",
            Platform.FACEBOOK: "facebook.com",
        }
        return domain_map[self]
