import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchButton", "mark"]

  connect() {
    // Initialize map centered at Meguro by default
    this.map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: 35.633998, lng: 139.715653 }, // Meguro
      zoom: 13,
      mapId: "YOUR_MAP_ID" // Optional if you have a custom Map ID
    });

    this.markers = []; // Track markers
  }

  search() {
    console.log("Search clicked 🚀");

    navigator.geolocation.getCurrentPosition(async (position) => {
      const userLat = position.coords.latitude;
      const userLng = position.coords.longitude;

      console.log(`User location: ${userLat}, ${userLng}`);

      const selectedCategories = Array.from(
        document.querySelectorAll('input[name="category"]:checked')
      ).map(cb => cb.value);

      if (selectedCategories.length === 0) {
        alert("Please select at least one category.");
        return;
      }

      // Clear old markers
      this.clearMarkers();

      // Clear old cards immediately
      this.markTarget.innerHTML = "";

      // For each selected category, perform Nearby Search
      for (const category of selectedCategories) {
        await this.nearbySearch(userLat, userLng, category);
      }
    });
  }

  async nearbySearch(lat, lng, category) {
    const { Place, SearchNearbyRankPreference } = await google.maps.importLibrary("places");
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

    const location = new google.maps.LatLng(lat, lng);

    const categoryType = this.getCategoryType(category);
    console.log(`Searching category: ${categoryType}`);

    const request = {
      fields: ["displayName", "location", "businessStatus"],
      locationRestriction: {
        center: location,
        radius: 3000, // 3km
      },
      includedPrimaryTypes: [categoryType],
      maxResultCount: 10,
      rankPreference: SearchNearbyRankPreference.POPULARITY,
      language: "en",
      region: "jp",
    };

    const { places } = await Place.searchNearby(request);

    if (places.length) {
      console.log(`Found ${places.length} places for ${categoryType}`);

      const { LatLngBounds } = await google.maps.importLibrary("core");
      const bounds = new LatLngBounds();

      places.forEach((place) => {
        const pos = place.location.toJSON();
        console.log(place)
        const markerView = new AdvancedMarkerElement({
          map: this.map,
          position: pos,
          title: place.displayName,
        });

        this.markers.push(markerView);
        bounds.extend(pos);

        // 🚀 Card with category badge and click-to-center feature
        const cardHtml = `
        <div class="container">
        <div class="d-flex justify-content-center">
        <div class="card mb-2" style="cursor: pointer; width: 400px;" onclick="
            const map = window.googleMapsStimulusMapInstance;
            map.setCenter({ lat: ${pos.lat}, lng: ${pos.lng} });
            map.setZoom(16);
          " style="width: 100px;">
            <div class="card-body shadow-sm d-flex justify-content-between">

               <div class="">
              <h5 class="card-title">${place.displayName}</h5>
              <span class="badge bg-primary mb-2">${category}</span>
              <p class="card-text">Business status: ${place.businessStatus || "Unknown"}</p>
               </div>

              <div class="">
              <a target="_blank" jstcache="6" href= "https://maps.google.com/maps/dir/?api=1&destination=${pos.lat},${pos.lng}" tabindex="0">
              <i class="fa-solid fa-location-dot fa-2xl"></i></a>
              </div>

            </div>
          </div>
        </div>
        </div>
        `;

        this.markTarget.insertAdjacentHTML("beforeend", cardHtml);
      });

      this.map.fitBounds(bounds);
    } else {
      console.log(`No results found for category: ${category}`);
    }
  }

  clearMarkers() {
    console.log("Clearing markers...");
    this.markers.forEach(marker => {
      marker.map = null; // Remove marker from map
    });
    this.markers = [];
  }

  getCategoryType(category) {
    switch (category) {
      case "Vet":
        return "veterinary_care";
      case "Petshop":
        return "pet_store";
      default:
        return "pet_store"; // Fallback
    }
  }
}
